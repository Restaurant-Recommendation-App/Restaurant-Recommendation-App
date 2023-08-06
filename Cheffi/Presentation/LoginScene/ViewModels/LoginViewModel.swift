//
//  LoginViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/06.
//

import Foundation
import Combine

protocol LoginViewModelInput {
    
}

protocol LoginViewModelOutput {
    
}

final class LoginViewModel: LoginViewModelInput & LoginViewModelOutput {
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    
    // MARK: - Output
    
    // MARK: - Init
    init() {
        
    }
}
