//
//  ProfileRepository.swift
//  Cheffi
//
//  Created by 김문옥 on 5/6/24.
//

import Foundation
import Combine

protocol ProfileRepository {
    func getProfile(id: Int?) -> AnyPublisher<(Results<ProfileDTO>, HTTPURLResponse), DataTransferError>
}
