//
//  SNSLoginViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import Combine
import UIKit

struct SNSLoginViewModelActions {
    let showProfileSetup: (_ navigationController: UINavigationController?) -> Void
}

protocol SNSLoginViewModelInput {
    
}

protocol SNSLoginViewModelOutput {
    func showProfileSetup(_ navigationController: UINavigationController?)
}

final class SNSLoginViewModel: SNSLoginViewModelInput & SNSLoginViewModelOutput {
    private let actions: SNSLoginViewModelActions?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    // MARK: - Output
    func showProfileSetup(_ navigationController: UINavigationController?) {
        actions?.showProfileSetup(navigationController)
    }
    
    // MARK: - Init
    init(actions: SNSLoginViewModelActions) {
        self.actions = actions
    }
}
