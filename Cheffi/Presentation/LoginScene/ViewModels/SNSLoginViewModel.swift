//
//  SNSLoginViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import Combine
import Foundation

struct SNSLoginViewModelActions {
    let showProfileSetup: () -> Void
}

protocol SNSLoginViewModelInput {
    func kakaoLoginDidTap()
    func appleLoginDidTap()
}

protocol SNSLoginViewModelOutput {
    var isKakaoLoginSuccess: AnyPublisher<User?, DataTransferError> { get }
    var isAppleLoginSuccess: AnyPublisher<Bool, Never> { get }
    func showProfileSetup()
}

protocol SNSLoginViewModelType {
    var input: SNSLoginViewModelInput { get }
    var output: SNSLoginViewModelOutput { get }
}

final class SNSLoginViewModel: SNSLoginViewModelType {
    var input: SNSLoginViewModelInput { return self }
    var output: SNSLoginViewModelOutput { return self }
    
    private let actions: SNSLoginViewModelActions
    private let useCase: AuthUseCase
    private var cancellables = Set<AnyCancellable>()
    private var kakaoLoginDidTapSubject = PassthroughSubject<Void, Never>()
    private var appleLoginDidTapSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(
        actions: SNSLoginViewModelActions,
        useCase: AuthUseCase
    ) {
        self.actions = actions
        self.useCase = useCase
    }
    
    // MARK: - Private
    private func authorizeKakao() -> AnyPublisher<User?, DataTransferError> {
        let subject = PassthroughSubject<User?, DataTransferError>()
        let loginAction: () -> Void
        
        if UserApi.isKakaoTalkLoginAvailable() {
            // Kakao Talk 로그인
            loginAction = { [weak self] in
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    self?.handleLoginResponse(subject: subject)(oauthToken?.idToken, error)
                }
            }
        } else {
            // Kakao 웹뷰 로그인
            loginAction = { [weak self] in
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    self?.handleLoginResponse(subject: subject)(oauthToken?.idToken, error)
                }
            }
        }
        
        loginAction()
        
        return subject.eraseToAnyPublisher()
    }
    
    private func handleLoginResponse(subject: PassthroughSubject<User?, DataTransferError>) -> (String?, Error?) -> Void {
        return { [weak self] token, error in
            guard let idToken = token else {
                subject.send(nil)
                subject.send(completion: .finished)
                return
            }
            
            if let error = error {
                subject.send(nil)
                subject.send(completion: .failure(.parsing(error)))
            } else {
                let cancellable = self?.useCase.postOauthKakaoLoing(idToken: idToken)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            subject.send(completion: .finished)
                        case .failure(let error):
                            subject.send(completion: .failure(error))
                        }
                    } receiveValue: { [weak self] user, response in
                        if let token = response.allHeaderFields["Authorization"] as? String {
                            self?.saveSessionToken(token)
                            subject.send(user)
                        } else {
                            self?.saveSessionToken(nil)
                            subject.send(nil)
                        }
                    }
                
                if let cancellable = cancellable {
                    self?.cancellables.insert(cancellable)
                }
            }
        }
    }
    
    private func authorizeApple() -> AnyPublisher<Bool, Never> {
        let subject = PassthroughSubject<Bool, Never>()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        let delegate = AuthorizationDelegate { success in
            subject.send(success)
            subject.send(completion: .finished)
        }
        controller.delegate = delegate
        controller.performRequests()
        
        return subject.eraseToAnyPublisher()
    }
    
    private func saveSessionToken(_ token: String?) {
        print("---------------------------------------")
        print("session token:", token ?? "-")
        print("---------------------------------------")
        UserDefaultsManager.AuthInfo.sessionToken = token
    }
}

// MARK: - SNSLoginViewModelInput
extension SNSLoginViewModel: SNSLoginViewModelInput {
    func kakaoLoginDidTap() {
        kakaoLoginDidTapSubject.send(())
    }
    
    func appleLoginDidTap() {
        appleLoginDidTapSubject.send(())
    }
}

// MARK: - SNSLoginViewModelOutput
extension SNSLoginViewModel: SNSLoginViewModelOutput {
    var isKakaoLoginSuccess: AnyPublisher<User?, DataTransferError> {
        return kakaoLoginDidTapSubject
            .flatMap { [weak self] _ -> AnyPublisher<User?, DataTransferError> in
                guard let self = self else {
                    return Future { promise in
                        promise(.success(nil))
                    }
                    .eraseToAnyPublisher()
                }
                return self.authorizeKakao()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var isAppleLoginSuccess: AnyPublisher<Bool, Never> {
        return appleLoginDidTapSubject
            .flatMap { [weak self] _ in
                self?.authorizeApple() ?? Just(false).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func showProfileSetup() {
        actions.showProfileSetup()
    }
}

// MARK: - AuthorizationDelegate
class AuthorizationDelegate: NSObject, ASAuthorizationControllerDelegate {
    private let completion: (Bool) -> Void
    
    init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let _ = authorization.credential as? ASAuthorizationAppleIDCredential {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion(false)
    }
}
