//
//  RestaurantRegistComposeView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantRegistComposeReducer.self)
struct RestaurantRegistComposeView: View {
    var body: some View {
        Text("RestaurantRegistComposeView")
    }
}

struct RestaurantRegistComposeView_Preview: PreviewProvider {
    static var previews: some View {
        RestaurantRegistComposeView(
            Store(initialState: RestaurantRegistComposeReducer.State()) {
                RestaurantRegistComposeReducer(steps: PassthroughSubject<RouteStep, Never>())._printChanges()
            }
        )
    }
}
