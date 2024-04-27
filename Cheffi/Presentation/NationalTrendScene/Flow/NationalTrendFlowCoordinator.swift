//
//  NationalTrendFlowCoordinator.swift
//  Cheffi
//
//  Created by USER on 2023/07/14.
//

import UIKit
import Combine

protocol NationalTrendFlowCoodinatorDependencies {
    func makeNationalTrendViewController(reducer: NationalTrendReducer) -> NationalTrendViewController
    func makeNationalTrendReducer(steps: PassthroughSubject<RouteStep, Never>) -> NationalTrendReducer
}
    
final class NationalTrendFlowCoodinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: AppFlowCoordinator?
    private let steps = PassthroughSubject<RouteStep, Never>()
    private var cancellables = Set<AnyCancellable>()
    var dependencies: NationalTrendFlowCoodinatorDependencies
    
    init(
        navigationController: UINavigationController?, 
        parentCoordinator: AppFlowCoordinator?,
        dependencies: NationalTrendFlowCoodinatorDependencies
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        steps
            .sink { [weak self] step in
                guard let self else { return }
                switch step {
                case .pushNationalTrend:
                    pushNationalTrend()
                case .dismissNationalTrend:
                    dismissNationalTrend()
                default: return
                }
            }
            .store(in: &cancellables)
        
        steps.send(.pushNationalTrend)
    }
    
    private func pushNationalTrend() {
        let reducer = dependencies.makeNationalTrendReducer(steps: steps)
        let vc = dependencies.makeNationalTrendViewController(reducer: reducer)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func dismissNationalTrend() {
        guard let navigationController else { return }
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            parentCoordinator?.setVCs(kind: .nationalTrend, root: navigationController)
        }
    }
}
