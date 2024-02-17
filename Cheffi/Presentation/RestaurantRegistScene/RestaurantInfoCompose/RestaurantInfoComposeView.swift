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
    private enum Metrics {
        static let safeAreaPadding = 16.0
        static let headlineTextPadding = EdgeInsets(top: 32, leading: 0, bottom: 4, trailing: 0)
        static let headlineTextHorizontalSpacing = 8.0
        static let photoListTopPadding = 12.0
        static let photoThumbnailImageSize = CGSize(width: 88.0, height: 88.0)
        static let attatchPhotoButtonContentsSpacing = 4.0
        static let attatchPhotoButtonViewPadding = 16.0
        static let attatchPhotoButtonPadding = 8.0
        static let attatchPhotoButtonCornerRadius = 8.0
    }
    
    @State private var isShowAlertAction: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBarView(store.scope(
                    state: \.navigationBarState,
                    action: RestaurantInfoComposeReducer.Action.navigaionBarAction
                ))
                
                // 사진첨부 영역
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("맛집에서의 경험은 어떠셨나요?")
                            .font(.custom("SUIT", size: 20).weight(.semibold))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.cheffiGray8)
                        
                        Spacer(minLength: Metrics.headlineTextHorizontalSpacing)
                        
                        Text("3개이상 등록")
                            .font(.custom("SUIT", size: 14))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.cheffiGray5)
                    }
                    .padding(Metrics.headlineTextPadding)
                    
                    if !viewStore.selectedImageDatas.isEmpty {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 8.0) {
                                ForEach(viewStore.selectedImageDatas, id: \.self) { data in
                                    if let uiImage = UIImage(data: data) {
                                        ZStack {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(
                                                    width: Metrics.photoThumbnailImageSize.width,
                                                    height: Metrics.photoThumbnailImageSize.height
                                                )
                                                .cornerRadius(Metrics.attatchPhotoButtonCornerRadius)
                                                .clipped()
                                            
                                            Button {
                                                viewStore.send(.deselectPhoto(data))
                                            } label: {
                                                Image(.icCloseCircle)
                                                    .position(CGPoint(
                                                        x: Metrics.photoThumbnailImageSize.width - 16.0,
                                                        y: 16.0
                                                    ))
                                            }
                                        }
                                        .animation(.snappy, value: data)
                                    }
                                }
                            }
                            .animation(.snappy, value: viewStore.selectedImageDatas)
                        }
                        .frame(height: Metrics.photoThumbnailImageSize.height)
                        .padding(.top, Metrics.photoListTopPadding)
                    }
                    
                    Button {
                        self.isShowAlertAction = true
                    } label: {
                        HStack(spacing: Metrics.attatchPhotoButtonContentsSpacing) {
                            Image(.attatchPhoto)
                            
                            Text("사진 첨부하기")
                                .font(.custom("SUIT", size: 14).weight(.medium))
                        }
                        .padding(Metrics.attatchPhotoButtonPadding)
                        .frame(maxWidth: .infinity)
                    }
                    .confirmationDialog(
                        "",
                        isPresented: $isShowAlertAction, 
                        titleVisibility: .hidden
                    ) {
                        Button("직접 찍기") {
                            viewStore.send(.startCamera)
                        }
                        
                        Button("앨범에서 선택") {
                            viewStore.send(.startAlbumSelection)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: Metrics.attatchPhotoButtonCornerRadius)
                            .inset(by: 0.5)
                            .stroke(
                                .cheffiPink1,
                                lineWidth: 1
                            )
                    )
                    .padding(.vertical, Metrics.attatchPhotoButtonViewPadding)
                    .foregroundColor(.mainCTA)
                } // 사진첨부 영역
                .animation(.snappy, value: viewStore.selectedImageDatas.isEmpty)
                
                // 리뷰작성 영역
                VStack(spacing: 0) {
                    Text("어떤 메뉴를 드셨나요?")
                        .font(.custom("SUIT", size: 20).weight(.semibold))
                        .foregroundColor(.cheffiGray8)
                        .padding(Metrics.headlineTextPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                } // 리뷰작성 영역
                
                // 메뉴선택 영역
                VStack(spacing: 0) {
                    
                } // 메뉴선택 영역
                
                Spacer()
                
                BottomButtonView(store.scope(
                    state: \.bottomButtonState,
                    action: RestaurantInfoComposeReducer.Action.bottomButtonAction
                ))
            }
            .padding(.horizontal, Metrics.safeAreaPadding)
        }
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
                ),
                selectedImageDatas: [
                    UIImage(resource: .icCamera).pngData()!,
                    UIImage(resource: .icAppleLogo).pngData()!,
                    UIImage(resource: .icArrowRight).pngData()!,
                    UIImage(resource: .loginBackground).pngData()!,
                    UIImage(resource: .icSearch).pngData()!
                ]
            )) {
                RestaurantInfoComposeReducer(
                    useCase: PreviewRestaurantRegistUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
