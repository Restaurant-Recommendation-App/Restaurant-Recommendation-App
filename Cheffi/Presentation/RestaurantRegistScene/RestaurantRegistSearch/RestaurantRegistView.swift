//
//  RestaurantRegistView.swift
//  Cheffi
//
//  Created by Eli_01 on 12/17/23.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantRegistReducer.self)
struct RestaurantRegistView: View {
    private enum Metrics {
        static let descriptionTextEdgeInsets = EdgeInsets(top: 8.0, leading: 16.0, bottom: 12.0, trailing: 0.0)
        static let suggestRegistHStackHeight = 48.0
        static let suggestRegistHStackEdgeInsets = EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
        static let barViewHeight = 1.0
        static let barViewEdgeInsets = EdgeInsets(top: 8.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
    }
    
    var body: some View {
        VStack {
            NavigationBarView(store.scope(
                state: \.navigationBarState,
                action: RestaurantRegistReducer.Action.navigaionBarAction
            ))
            
            SearchBarView(store.scope(
                state: \.searchBarState,
                action: RestaurantRegistReducer.Action.searchBarAction
            ))
            
            if viewStore.searchBarState.searchQuery.isEmpty {
                if viewStore.isEmptyNearRestaurant {
                    EmptyDescriptionView(store.scope(
                        state: \.nearRestaurantEmptyState,
                        action: RestaurantRegistReducer.Action.nearRestaurantEmptyAction
                    ))
                    
                    Spacer()
                } else {
                    HStack {
                        Text("근처 가장많은\n맛집등록이 된 곳이에요")
                            .font(
                                Font.custom("SUIT", size: 18)
                                    .weight(.bold)
                            )
                            .foregroundColor(.cheffiGray8)
                            .lineSpacing(8.0)
                            .padding(Metrics.descriptionTextEdgeInsets)
                        
                        Spacer()
                    }
                    
                    NearRestaurantListView(store.scope(
                        state: \.nearRestaurantListState,
                        action: RestaurantRegistReducer.Action.nearRestaurantListAction
                    ))
                    
                    Spacer()
                }
            } else {
                if viewStore.isEmptyRestaurant {
                    EmptyDescriptionView(store.scope(
                        state: \.restaurantEmptyState,
                        action: RestaurantRegistReducer.Action.restaurantEmptyAction
                    ))
                    
                    Spacer()
                } else {
                    HStack {
                        Text("찾고있는 맛집이 없나요?")
                            .font(
                                Font.custom("SUIT", size: 15)
                                    .weight(.semibold)
                            )
                            .foregroundColor(.cheffiGray8)
                        
                        Spacer()
                        
                        EmptyViewButton(store.scope(
                            state: \.emptyViewButtonState,
                            action: RestaurantRegistReducer.Action.emptyViewButtonAction
                        ))
                    }
                    .padding(Metrics.suggestRegistHStackEdgeInsets)
                    
                    Rectangle()
                        .frame(height: Metrics.barViewHeight)
                        .foregroundColor(.cheffiWhite05)
                        .padding(Metrics.barViewEdgeInsets)

                    RestaurantListView(store.scope(
                        state: \.restaurantListState,
                        action: RestaurantRegistReducer.Action.restaurantListAction
                    ))
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

struct RestaurantRegistView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRegistView(
            Store(initialState: RestaurantRegistReducer.State()) {
                RestaurantRegistReducer(
                    useCase: PreviewRestaurantRegistUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )
                    ._printChanges()
            }
        )
    }
}
