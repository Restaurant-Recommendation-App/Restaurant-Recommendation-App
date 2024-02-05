//
//  RestaurantInfoComposeView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantInfoComposeReducer.self)
struct RestaurantInfoComposeView: View {
    var body: some View {
        Text(viewStore.restaurant.name)
    }
}

struct RestaurantInfoComposeView_Preview: PreviewProvider {
    static var previews: some View {
        RestaurantInfoComposeView(
            Store(initialState: RestaurantInfoComposeReducer.State(
                restaurant: RestaurantInfoDTO(
                    id: 0,
                    name: "기사식당",
                    address: Address(
                        province: "서울",
                        city: "강북구",
                        roadName: "한천로 140길",
                        fullLotNumberAddress: "111-22",
                        fullRodNameAddress: "11-22"
                    ),
                    registered: false
                )
            )) {
                RestaurantInfoComposeReducer(steps: PassthroughSubject<RouteStep, Never>())._printChanges()
            }
        )
    }
}
