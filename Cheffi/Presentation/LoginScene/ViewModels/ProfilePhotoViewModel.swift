//
//  ProfilePhotoViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Foundation
import Combine

struct ProfilePhotoViewModelActions {
    let showPhotoAlbum: () -> Void
}

protocol ProfilePhotoViewModelInput {
}

protocol ProfilePhotoViewModelOutput {
    func showPhotoAlbum()
}

typealias ProfilePhotoViewModelType = ProfilePhotoViewModelInput & ProfilePhotoViewModelOutput

final class ProfilePhotoViewModel: ProfilePhotoViewModelType {
    // MARK: - Input
    // MARK: - Output
    func showPhotoAlbum() {
        actions.showPhotoAlbum()
    }
    
    // MARK: - Init
    private var cancellables: Set<AnyCancellable> = []
    private let actions: ProfilePhotoViewModelActions
    init(actions: ProfilePhotoViewModelActions) {
        self.actions = actions
    }
}
