//
//  MyPageView.swift
//  Cheffi
//
//  Created by 김문옥 on 4/5/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(MyPageReducer.self)
struct MyPageView: View {
    @State private var currentTabIndex: Int = 0
    @State private var readedReviewThumbnailListHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(store.scope(
                state: \.navigationBarState,
                action: { .navigationBarAction($0) }
            ))
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    HStack(spacing: 24.0) {
                        Image("empty_menu_background")
                            .frame(width: 100.0, height: 100.0)
                            .cornerRadius(50.0)
                        
                        VStack(spacing: 18.0) {
                            HStack(alignment: .center, spacing: 22.0) {
                                VStack(spacing: 2.0) {
                                    Text("\(viewStore.profile?.post ?? 0)")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("리뷰")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                                
                                Rectangle()
                                    .frame(width: 1.0, height: 20.0)
                                    .foregroundColor(.cheffiGray2)
                                
                                VStack(spacing: 2.0) {
                                    Text("\(viewStore.profile?.followerCount ?? 0)")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("팔로워")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                                
                                Rectangle()
                                    .frame(width: 1.0, height: 20.0)
                                    .foregroundColor(.cheffiGray2)
                                
                                VStack(spacing: 2.0) {
                                    Text("\(viewStore.profile?.followingCount ?? 0)")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("팔로잉")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                            }
                            
                            Button {
                                
                            } label: {
                                Text("프로필 수정")
                                    .font(.custom("SUIT", size: 15).weight(.medium))
                                    .foregroundColor(.cheffiGray6)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.5)
                                            .stroke(
                                                .cheffiGray3,
                                                lineWidth: 1
                                            )
                                    )
                            }
                            .frame(height: 32.0)
                        }
                    }
                    .padding(.bottom, 20.0)
                    
                    Text(viewStore.profile?.nickname?.value ?? "김맛집")
                        .font(.custom("SUIT", size: 20).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.bottom, 10.0)
                    
                    Text(viewStore.profile?.introduction ?? "\(viewStore.profile?.nickname?.value ?? "김맛집") 쉐피입니다 :)")
                        .font(.custom("SUIT", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.bottom, 16.0)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 12.0) {
                            Text("\(viewStore.profile?.cheffiCoin ?? 0)")
                                .font(.custom("SUIT", size: 16).weight(.semibold))
                                .foregroundColor(.mainCTA)
                            
                            Text("CFC")
                                .font(.custom("SUIT", size: 16).weight(.semibold))
                        }
                        .frame(height: 32.0)
                        .padding(.horizontal, 16.0)
                        .background(.cheffiWhite05)
                        .cornerRadius(8.0)
                        
                        Spacer()
                    }
                    .padding(.bottom, 12.0)
                    
                    FlexibleTagListView(
                        data: viewStore.profile?.tags ?? [],
                        spacing: 8.0,
                        alignment: .leading
                    ) { item in
                        Text(verbatim: item.name)
                            .font(.custom("SUIT", size: 15).weight(.medium))
                            .foregroundColor(.cheffiGray7)
                            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                            .background(
                                RoundedRectangle(cornerRadius: 1000)
                                    .inset(by: 0.5)
                                    .stroke(.cheffiGray1, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 16.0)
                }
                .padding(.horizontal, 16.0)
                
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Color.cheffiWhite05
                            .frame(height: 2.0)
                        
                        MenuTabBarView(
                            currentTabIndex: $currentTabIndex,
                            tabBarItemNames: [
                                "내 리뷰",
                                "구매한 리뷰",
                                "찜한 리뷰"
                            ]
                        )
                        .padding(.horizontal, 16.0)
                    }
                    .padding(.bottom, 16.0)
                    
                    ZStack {
                        Color.clear
                            .frame(width: 1)
                            .readSize { size in
                                readedReviewThumbnailListHeight = size.height
                            }
                        
                        TabView(selection: $currentTabIndex) {
                            if viewStore.isEmptyMyReviewThumbnailList {
                                VStack(spacing: 0) {
                                    EmptyDescriptionView(store.scope(
                                        state: \.myReviewEmptyState,
                                        action: { .restaurantEmptyAction($0) }
                                    ))
                                    .frame(minHeight: 274)
                                    
                                    Spacer()
                                }
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(0)
                            } else {
                                ReviewThumbnailListView(store.scope(
                                    state: \.myReviewThumbnailListState,
                                    action: { .myReviewThumbnailListAction($0) }
                                ))
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(0)
                            }
                            
                            if viewStore.isEmptyPurchasedReviewThumbnailList {
                                VStack(spacing: 0) { 
                                    Image(.emptyPurchasedReviewThumbnailList)
                                        .padding(.top, 106.0)
                                    
                                    Text("구매한 리뷰가 없어요")
                                        .font(.custom("SUIT", size: 16))
                                        .foregroundColor(.cheffiGray6)
                                        .padding(.top, 20.0)
                                    
                                    Spacer()
                                }
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(1)
                            } else {
                                ReviewThumbnailListView(store.scope(
                                    state: \.purchasedReviewThumbnailListState,
                                    action: { .purchasedReviewThumbnailListAction($0) }
                                ))
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(1)
                            }
                            
                            if viewStore.isEmptyBookmarkedReviewThumbnailList {
                                VStack(spacing: 0) {
                                    Image(.emptyBookmarkedReviewThumbnailList)
                                        .padding(.top, 106.0)
                                    
                                    Text("찜한 리뷰가 없어요")
                                        .font(.custom("SUIT", size: 16))
                                        .foregroundColor(.cheffiGray6)
                                        .padding(.top, 14.0)
                                    
                                    Spacer()
                                }
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(2)
                            } else {
                                ReviewThumbnailListView(store.scope(
                                    state: \.bookmarkedReviewThumbnailListState,
                                    action: { .bookmarkedReviewThumbnailListAction($0) }
                                ))
                                .readSize { size in
                                    readedReviewThumbnailListHeight = size.height
                                }
                                .tag(2)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: readedReviewThumbnailListHeight)
                    }
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

struct MyPageView_Preview: PreviewProvider {
    static var previews: some View {
        MyPageView(
            Store(initialState: MyPageReducer.State()) {
                MyPageReducer(
                    useCase: PreviewProfileUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
