//
//  ProfilePhotoViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import Foundation
import Combine

struct ProfilePhotoViewModelActions {
    let showPhotoAlbum: (_ dismissCompltion: ((Data?) -> Void)?) -> Void
}

protocol ProfilePhotoViewModelInput {
}

protocol ProfilePhotoViewModelOutput {
    func showPhotoAlbum(_ dismissCompltion: ((Data?) -> Void)?)
}

typealias ProfilePhotoViewModelType = ProfilePhotoViewModelInput & ProfilePhotoViewModelOutput

final class ProfilePhotoViewModel: ProfilePhotoViewModelType {
    // MARK: - Input
    // MARK: - Output
    func showPhotoAlbum(_ dismissCompltion: ((Data?) -> Void)?) {
        actions.showPhotoAlbum(dismissCompltion)
    }
    
    // MARK: - Init
    private var cancellables: Set<AnyCancellable> = []
    private let actions: ProfilePhotoViewModelActions
    init(actions: ProfilePhotoViewModelActions) {
        self.actions = actions
    }
}
