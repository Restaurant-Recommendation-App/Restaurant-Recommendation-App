//
//  ReviewWriterInfoDTO.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/19/23.
//

import Foundation

struct ReviewWriterInfoDTO: Codable {
    let id: Int // 리뷰 작성자 ID
    let name: String // 리뷰 작성자 닉네임
    let photoUrl: String // 리뷰 작성자 프로필 사진 URL
    let introduction: String? // 리뷰 작성자 소개글
    let writtenByViewer: Bool // 조회자(유저)가 작성자인지 여부
    
    enum CodingKeys: String, CodingKey {
        case id, name, introduction
        case photoUrl = "photo_url"
        case writtenByViewer = "written_by_viewer"
    }
}
