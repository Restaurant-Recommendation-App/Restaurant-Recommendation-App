//
//  DefaultAreaRepository.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/23.
//

import Foundation
import Combine

final class DefaultAreaRepository {
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

extension DefaultAreaRepository: AreaRepository {
    func getAreas() -> AnyPublisher<[AreaDTO], Never> {
        //TODO: service 사용하여 API 연동
        
        let areas: [AreaDTO] = [
            AreaDTO(
                si: "서울시",
                gu: [
                    "관악구", "성동구", "영등포구", "종로구", "강남구", "광천구", "구로구", "노원구", "도봉구",
                    "서초구", "성복구", "성남구", "서대문구", "송파구", "강동구", "강서구", "중랑구", "양천구"
                ]
            ),
            AreaDTO(si: "부산시", gu: ["1"]),
            AreaDTO(si: "천안시", gu: ["2"]),
            AreaDTO(si: "인천시", gu: ["3"]),
            AreaDTO(si: "부천시", gu: ["4"]),
            AreaDTO(si: "경기", gu: ["5"]),
            AreaDTO(si: "강원", gu: ["6"]),
            AreaDTO(si: "충북", gu: ["7"]),
            AreaDTO(si: "전북", gu: ["8"]),
            AreaDTO(si: "충남/대전",gu: ["9"]),
            AreaDTO(si: "경남/울산",gu: ["10"]),
            AreaDTO(si: "경북/대구",gu: ["11"]),
            AreaDTO(si: "전남/광주",gu: ["12"]),
            AreaDTO(si: "제주시",gu: ["13"])
        ]
        
        return Just(areas).eraseToAnyPublisher()
    }
}
