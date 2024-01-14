//
//  RestaurantListView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/8/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantListReducer.self)
struct RestaurantListView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewStore.restaurantList, id: \.self) { restaurant in
                    RestaurantItemView(restaurant: restaurant, itemWidth: .infinity)
                }
            }
        }
    }
}

struct RestaurantListView_Preview: PreviewProvider {
    static var previews: some View {
        RestaurantListView(
            Store(initialState: RestaurantListReducer.State()) {
                RestaurantListReducer()._printChanges()
            }
        )
    }
}
