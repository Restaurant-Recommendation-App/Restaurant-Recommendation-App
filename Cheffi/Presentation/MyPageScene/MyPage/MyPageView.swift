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
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(store.scope(
                state: \.navigationBarState,
                action: { .navigationBarAction($0) }
            ))
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    HStack(spacing: 24.0) {
                        // TODO: viewStore.thumbnail
                        Image("empty_menu_background")
                            .frame(width: 100.0, height: 100.0)
                            .cornerRadius(50.0)
                        
                        VStack(spacing: 18.0) {
                            HStack(alignment: .center, spacing: 22.0) {
                                VStack(spacing: 2.0) {
                                    // TODO: viewStore.review
                                    Text("134546752324354656452")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("리뷰")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                                .frame(width: .infinity)
                                
                                Rectangle()
                                    .frame(width: 1.0, height: 20.0)
                                    .foregroundColor(.cheffiGray2)
                                
                                VStack(spacing: 2.0) {
                                    // TODO: viewStore.followers
                                    Text("4312542343452452345")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("팔로워")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                                .frame(width: .infinity)
                                
                                Rectangle()
                                    .frame(width: 1.0, height: 20.0)
                                    .foregroundColor(.cheffiGray2)
                                
                                VStack(spacing: 2.0) {
                                    // TODO: viewStore.followings
                                    Text("4554534234543423")
                                        .lineLimit(1)
                                        .font(.custom("SUIT", size: 18).weight(.semibold))
                                        .foregroundColor(.cheffiBlack)
                                    
                                    Text("팔로잉")
                                        .font(.custom("SUIT", size: 12))
                                        .foregroundColor(.cheffiGray8)
                                }
                                .frame(width: .infinity)
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
                            .frame(width: .infinity, height: 32.0)
                        }
                    }
                    .padding(.bottom, 20.0)
                    
                    // TODO: viewStore.nickname
                    Text("김맛집")
                        .font(.custom("SUIT", size: 20).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.bottom, 10.0)
                    
                    // TODO: viewStore.introduction
                    Text("김맛집 쉐피 입니다 :)")
                        .font(.custom("SUIT", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.bottom, 16.0)
                    
                    HStack(spacing: 0) {
                        HStack(spacing: 12.0) {
                            Text("456")
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
                        data: viewStore.allTags,
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
                }
            }
            .padding(.horizontal, 16.0)
        }
    }
}

struct MyPageView_Preview: PreviewProvider {
    static var previews: some View {
        MyPageView(
            Store(initialState: MyPageReducer.State()) {
                MyPageReducer(
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
