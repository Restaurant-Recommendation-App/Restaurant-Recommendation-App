//
//  MyPageFlowCoodinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import Combine

protocol MyPageFlowCoodinatorDependencies {
    func makeMyPageViewController(reducer: MyPageReducer) -> MyPageViewController
    func makeMyPageReducer(steps: PassthroughSubject<RouteStep, Never>) -> MyPageReducer
}

final class MyPageFlowCoodinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    private let steps = PassthroughSubject<RouteStep, Never>()
    private var cancellables = Set<AnyCancellable>()
    var dependencies: MyPageFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController?, parentCoordinator: AppFlowCoordinator?, dependencies: MyPageFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        steps
            .sink { [weak self] step in
                guard let self else { return }
                switch step {
                case .pushMyPage:
                    pushMyPage()
                default: return
                }
            }
            .store(in: &cancellables)
        
        steps.send(.pushMyPage)
    }
    
    private func pushMyPage() {
        let reducer = dependencies.makeMyPageReducer(steps: steps)
        let vc = dependencies.makeMyPageViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
}
