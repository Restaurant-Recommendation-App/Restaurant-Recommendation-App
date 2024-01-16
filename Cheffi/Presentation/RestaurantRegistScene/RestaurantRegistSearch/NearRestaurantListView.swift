//
//  NearRestaurantListView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/6/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

@ViewStore(NearRestaurantListReducer.self)
struct NearRestaurantListView: View {
    private enum Metrics {
        static let gridCount = 4
        static let itemWidth = 285.0
        static let itemHeight = 72.0
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(
                rows: Array(repeating: GridItem(.fixed(Metrics.itemHeight)), count: Metrics.gridCount),
                spacing: 0
            ) {
                ForEach(viewStore.nearRestaurantList, id: \.self) { restaurant in
                    RestaurantItemView(restaurant: restaurant, itemWidth: Metrics.itemWidth)
                }
            }
        }
    }
}

struct NearRestaurantListView_Preview: PreviewProvider {
    static var previews: some View {
        NearRestaurantListView(
            Store(initialState: NearRestaurantListReducer.State()) {
                NearRestaurantListReducer()._printChanges()
            }
        )
    }
}
