//
//  SearchRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/27.
//

import Foundation
import Combine

protocol SearchRepository {
    func getRecentSearch(withCategory category: SearchCategory) -> AnyPublisher<[String], Never>
}
