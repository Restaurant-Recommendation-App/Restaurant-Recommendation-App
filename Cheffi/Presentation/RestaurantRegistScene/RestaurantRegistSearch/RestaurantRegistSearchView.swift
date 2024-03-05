//
//  RestaurantRegistSearchView.swift
//  Cheffi
//
//  Created by Eli_01 on 12/17/23.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(RestaurantRegistSearchReducer.self)
struct RestaurantRegistSearchView: View {
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
                action: RestaurantRegistSearchReducer.Action.navigationBarAction
            ))
            
            SearchBarView(store.scope(
                state: \.searchBarState,
                action: RestaurantRegistSearchReducer.Action.searchBarAction
            ))
            
            if viewStore.searchBarState.searchQuery.isEmpty {
                if viewStore.isEmptyNearRestaurant {
                    EmptyDescriptionView(store.scope(
                        state: \.nearRestaurantEmptyState,
                        action: RestaurantRegistSearchReducer.Action.nearRestaurantEmptyAction
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
                        action: RestaurantRegistSearchReducer.Action.nearRestaurantListAction
                    ))
                    
                    Spacer()
                }
            } else {
                if viewStore.isEmptyRestaurant {
                    EmptyDescriptionView(store.scope(
                        state: \.restaurantEmptyState,
                        action: RestaurantRegistSearchReducer.Action.restaurantEmptyAction
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
                            action: RestaurantRegistSearchReducer.Action.emptyViewButtonAction
                        ))
                    }
                    .padding(Metrics.suggestRegistHStackEdgeInsets)
                    
                    Rectangle()
                        .frame(height: Metrics.barViewHeight)
                        .foregroundColor(.cheffiWhite05)
                        .padding(Metrics.barViewEdgeInsets)

                    RestaurantListView(store.scope(
                        state: \.restaurantListState,
                        action: RestaurantRegistSearchReducer.Action.restaurantListAction
                    ))
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

struct RestaurantRegistSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRegistSearchView(
            Store(initialState: RestaurantRegistSearchReducer.State()) {
                RestaurantRegistSearchReducer(
                    useCase: PreviewRestaurantRegistUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )
                    ._printChanges()
            }
        )
    }
}
