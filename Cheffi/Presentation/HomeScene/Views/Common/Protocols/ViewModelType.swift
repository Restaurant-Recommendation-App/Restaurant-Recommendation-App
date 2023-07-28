//
//  ViewModelType.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/28.
//

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    
    func transform(input: Input) -> Output
}
