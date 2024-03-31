//
//  ReviewHashtagsView.swift
//  Cheffi
//
//  Created by 김문옥 on 3/2/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(ReviewHashtagsReducer.self)
struct ReviewHashtagsView: View {
    private enum Metrics {
        static let headlinePadding = EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16)
        static let sectionTitlePadding = EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16)
        static let tagListPadding = EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16)
        static let tagItemPadding = EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        static let tagSpacing = 8.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(store.scope(
                state: \.navigationBarState,
                action: ReviewHashtagsReducer.Action.navigationBarAction
            ))
        
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Text("나만의 맛집을 나타내는\n해시태그를 선택해주세요!")
                        .font(.custom("SUIT", size: 22).weight(.semibold))
                        .foregroundColor(.cheffiGray9)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Metrics.headlinePadding)
                    
                    Text("음식 종류 (1개 이상)")
                        .font(.custom("SUIT", size: 15).weight(.medium))
                        .foregroundColor(.cheffiGray6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Metrics.sectionTitlePadding)
                    
                    FlexibleTagListView(
                        data: viewStore.allTags.filter { $0.type == .food },
                        spacing: Metrics.tagSpacing,
                        alignment: .leading
                    ) { item in
                        TagItemButton {
                            viewStore.send(.tagButtonTapped(item))
                        } label: {
                            Text(verbatim: item.name)
                                .font(.custom("SUIT", size: 15).weight(.medium))
                                .padding(Metrics.tagItemPadding)
                        }
                    }
                    .padding(Metrics.tagListPadding)
                    
                    Text("맛과 특징 (2개이상)")
                        .font(.custom("SUIT", size: 15).weight(.medium))
                        .foregroundColor(.cheffiGray6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Metrics.sectionTitlePadding)
                    
                    FlexibleTagListView(
                        data: viewStore.allTags.filter { $0.type == .taste },
                        spacing: Metrics.tagSpacing,
                        alignment: .leading
                    ) { item in
                        TagItemButton {
                            viewStore.send(.tagButtonTapped(item))
                        } label: {
                            Text(verbatim: item.name)
                                .font(.custom("SUIT", size: 15).weight(.medium))
                                .padding(Metrics.tagItemPadding)
                        }
                    }
                    .padding(Metrics.tagListPadding)
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

struct ReviewHashtagsView_Preview: PreviewProvider {
    static var previews: some View {
        ReviewHashtagsView(
            Store(initialState: ReviewHashtagsReducer.State(
                reviewRequestInfo: .posting(
                    review: RegisterReviewRequest(
                        restaurantId: 1234,
                        registered: false,
                        title: "기사식당",
                        text: "훌륭한 맛입니다.",
                        menus: [
                            MenuDTO(
                                name: "Pizza",
                                price: 14000,
                                description: nil
                            ),
                            MenuDTO(
                                name: "Cheeze Pizza",
                                price: 19000,
                                description: nil
                            )
                        ],
                        tags: TagsChangeRequest(foodTags: [], tasteTags: [])
                    ),
                    imageDatas: []
                ),
                navigationBarState: NavigationBarReducer.State(
                    title: "",
                    leftButtonKind: .back,
                    rightButtonTitle: "게시하기"
                )
            )) {
                ReviewHashtagsReducer(
                    useCase: PreviewReviewUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )
                    ._printChanges()
            }
        )
    }
}
