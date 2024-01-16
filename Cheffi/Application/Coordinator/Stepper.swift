//
//  Stepper.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import Foundation
import Combine

protocol Stepper {
    var steps: PassthroughSubject<RouteStep, Never> { get }
}
