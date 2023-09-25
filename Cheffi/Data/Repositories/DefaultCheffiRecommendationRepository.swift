//
//  DefaultCheffiRecommendationRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/08/18.
//

import Foundation
import Combine

class DefaultCheffiRecommendationRepository {
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

extension DefaultCheffiRecommendationRepository: CheffiRecommendationRepository {
    func getTags() -> AnyPublisher<[String], Never> {
        // TODO: 서비스 객체 사용
        Just(["한식", "양식", "중식", "일식", "퓨전", "샐러드"]).eraseToAnyPublisher()
    }
    
    func getContents(with tag: String, page: Int) -> AnyPublisher<[ContentsResponseDTO.contentDTO], Never> {
        // TODO: 서비스 객체 사용, 서버 데이터 만들어지면 제거 필요, 현재는 가상 데이터 사용
        Just(moreContents(tag: tag)).eraseToAnyPublisher()
    }
    
    // TODO: 무한 스크롤링을 위하여 임시 생성, 제거 필요
    private func moreContents(tag: String) -> [ContentsResponseDTO.contentDTO] {
        let limit = (tag == "popularity") ? 47 : 10
        
        var contents = [ContentsResponseDTO.contentDTO]()
        for index in 0 ..< limit {
            contents.append(
                ContentsResponseDTO.contentDTO(
                    title: "(\(tag)) 그시절낭만의 근본 경양식 돈가스\(index)",
                    subtitle: "짬뽕 외길의 근본의 식당 외길인생이 느껴짐 이랄 ...",
                    contentTimeLockSeconds: Int.random(in: 400000 ..< 86400000)
//                    contentTimeLockSeconds: 303000
                )
            )
        }
        
        return contents
    }
}
