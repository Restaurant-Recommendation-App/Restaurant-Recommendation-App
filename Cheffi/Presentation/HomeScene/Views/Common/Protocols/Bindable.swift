//
//  Bindable.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/28.
//

import Combine

protocol Bindable {    
    associatedtype ViewModel: ViewModelType
    
    var cancellables: Set<AnyCancellable> { get set }
    
    func bind(to viewModel: ViewModel)
}
