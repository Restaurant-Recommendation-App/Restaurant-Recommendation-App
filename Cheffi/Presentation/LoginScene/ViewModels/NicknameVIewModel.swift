//
//  NicknameVIewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Foundation
import Combine

enum NicknameMessageStatus {
    case error
    case success
    case none
}


protocol NicknameViewModelInput {
    var nickname: PassthroughSubject<String, Never> { get }
    func checkNicknameDuplication()
}

protocol NicknameViewModelOutput {
    var isDuplicationCheckButtonEnabled: AnyPublisher<Bool, Never> { get }
    var message: AnyPublisher<String?, Never> { get }
    var messageStatus: AnyPublisher<NicknameMessageStatus, Never> { get }
    var maxNicknameCount: Int { get }
}

typealias NicknameViewModelType = NicknameViewModelInput & NicknameViewModelOutput

class NicknameViewModel: NicknameViewModelType {
    // MARK: - Input
    var nickname = PassthroughSubject<String, Never>()
    func checkNicknameDuplication() {
        // 네트워크 통신을 통해 닉네임 중복 확인
        let isDuplicated = false // 네트워크 결과에 따라 변경
        
        if isDuplicated {
            _message.send("이미 사용중인 닉네임 입니다.")
            _messageStatus.send(.error)
        } else {
            _message.send("사용 가능한 닉네임이에요 !")
            _messageStatus.send(.success)
        }
    }
    
    // MARK: - Output
    var maxNicknameCount: Int = 8
    private var _isDuplicationCheckButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    var isDuplicationCheckButtonEnabled: AnyPublisher<Bool, Never> {
        return _isDuplicationCheckButtonEnabled.eraseToAnyPublisher()
    }
    
    private var _message = CurrentValueSubject<String?, Never>("")
    var message: AnyPublisher<String?, Never> {
        return _message.eraseToAnyPublisher()
    }
    
    private var _messageStatus = CurrentValueSubject<NicknameMessageStatus, Never>(.none)
    var messageStatus: AnyPublisher<NicknameMessageStatus, Never> {
        return _messageStatus.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init() {
        nickname
            .sink { [weak self] in
                if $0.count >= self?.maxNicknameCount ?? 8 {
                    self?._message.send("8글자 이상은 입력되지 않습니다.")
                    self?._messageStatus.send(.error)
                } else {
                    self?._isDuplicationCheckButtonEnabled.send($0.count >= 2)
                    self?._message.send("")
                    self?._messageStatus.send(.none)
                }
            }
            .store(in: &cancellables)
    }
}

