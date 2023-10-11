//
//  SNSLoginViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import Combine
import Foundation

struct SNSLoginViewModelActions {
    let showProfileSetup: () -> Void
}

protocol SNSLoginViewModelInput {
    
}

protocol SNSLoginViewModelOutput {
    func showProfileSetup()
}

typealias SNSLoginViewModelType = SNSLoginViewModelInput & SNSLoginViewModelOutput

final class SNSLoginViewModel: SNSLoginViewModelType {
    private let actions: SNSLoginViewModelActions?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    // MARK: - Output
    func showProfileSetup() {
        actions?.showProfileSetup()
    }
    
    // MARK: - Init
    init(actions: SNSLoginViewModelActions) {
        self.actions = actions
    }
}
