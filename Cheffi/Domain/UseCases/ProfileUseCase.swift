//
//  ProfileUseCase.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation
import Combine

protocol ProfileUseCase {
    func getProfile(id: Int?) -> AnyPublisher<Profile, DataTransferError>
}

final class DefaultProfileUseCase: ProfileUseCase {
    
    let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func getProfile(id: Int?) -> AnyPublisher<Profile, DataTransferError> {
        repository.getProfile(id: id)
            .map { $0.0.data.toDomain() }
            .eraseToAnyPublisher()
    }
}

final class PreviewProfileUseCase: ProfileUseCase {
    func getProfile(id: Int?) -> AnyPublisher<Profile, DataTransferError> {
        Future { promise in
            promise(.success(
                Profile(
                    id: 1,
                    nickname: Nickname(
                        value: "김쉐피",
                        lastUpdatedDate: nil,
                        changeable: true
                    ),
                    introduction: "저는 김쉐피입니다.",
                    photoURL: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/logo.png",
                    followerCount: 324546,
                    followingCount: 869373,
                    post: 3654,
                    cheffiCoin: 248,
                    point: 452,
                    tags: [
                        Tag(id: 0, type: .food, name: "매콤한"),
                        Tag(id: 1, type: .food, name: "노포"),
                        Tag(id: 2, type: .food, name: "웨이팅 짧은"),
                        Tag(id: 3, type: .food, name: "아시아음식"),
                        Tag(id: 4, type: .food, name: "한식"),
                        Tag(id: 5, type: .food, name: "비건"),
                        Tag(id: 6, type: .food, name: "분위기 있는 곳")
                    ],
                    following: false,
                    blocking: false
                )
            ))
        }
        .eraseToAnyPublisher()
    }
}
