//
//  DefaultSearchRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/27.
//

import Foundation
import Combine

final class DefaultSearchRepository {
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DispatchQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultSearchRepository: SearchRepository {
    func getRecentSearch(withCategory category: SearchCategory) -> AnyPublisher<[String], Never> {
        //TODO: service 사용하여 API 연동
        let recentSearch: [String]
        switch category {
        case .food:
            recentSearch = ["노포", "치킨", "피자", "치킨이 먹고싶다", "탕수육", "순대", "떡볶아", "일본 길거리 음식", "한국음식", "중국집"]
        case .area:
            recentSearch = ["하이", "이", "Hello", "치킨이 먹고싶다", "탕수육", "순대", "떡볶아", "일본 길거리 음식", "한국음식", "중국집"]
        }
        
        return Just(recentSearch).eraseToAnyPublisher()
    }
}
