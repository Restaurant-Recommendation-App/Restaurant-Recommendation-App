//
//  AuthRepository.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/8/23.
//

import Foundation
import Combine

protocol AuthRepository {
    // 카카오 로그인
    func postOauthKakaoLogin(idToken: String) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError>
    // 약관 동의
    func patchTerms(adAgreed: Bool, analysisAgreed: Bool) -> AnyPublisher<(Results<UserDTO>, HTTPURLResponse), DataTransferError>
    // 닉네임 중복 확인
    func getNicknameInuse(nickname: String) -> AnyPublisher<(Results<Bool>, HTTPURLResponse), DataTransferError>
    // 닉네임 변경
    func patchNickname(nickname: String) -> AnyPublisher<(Results<String>, HTTPURLResponse), DataTransferError>
}
