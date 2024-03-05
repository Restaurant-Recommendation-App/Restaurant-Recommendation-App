//
//  ReviewComposeView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/14/24.
//

import SwiftUI
import Combine
import ComposableArchitecture
import ViewStore

@ViewStore(ReviewComposeReducer.self)
struct ReviewComposeView: View {
    private enum Metrics {
        static let outsidePadding = 16.0
        static let headlineTextPadding = EdgeInsets(top: 32, leading: 0, bottom: 4, trailing: 0)
        static let headlineTextHorizontalSpacing = 8.0
        static let photoListTopPadding = 12.0
        static let photoThumbnailImageSize = CGSize(width: 88.0, height: 88.0)
        static let attatchPhotoButtonContentsSpacing = 4.0
        static let attatchPhotoButtonViewPadding = 16.0
        static let attatchPhotoButtonPadding = 8.0
        static let attatchPhotoButtonCornerRadius = 8.0
        static let smallHeadlineTextTopPadding = 8.0
        static let mainTextEditorHeight = 192.0
        static let textFieldTopPadding = 8.0
        static let menuAskingDescriptionTextPadding = EdgeInsets(top: 2, leading: 0, bottom: 6, trailing: 0)
        static let menuAskingBackgroundImagePadding = EdgeInsets(top: 56, leading: 0, bottom: 24, trailing: 0)
        static let menuItemHStackSpacing = 12.0
        static let menuItemHStackTopPadding = 16.0
        static let menuAreaBottomPadding = 8.0
    }
    
    @State private var isShowAlertAction: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBarView(store.scope(
                    state: \.navigationBarState,
                    action: ReviewComposeReducer.Action.navigationBarAction
                ))
                
                ScrollView(.vertical) {
                    // 사진첨부 영역
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("맛집에서의 경험은 어떠셨나요?")
                                .font(.custom("SUIT", size: 20).weight(.semibold))
                                .foregroundColor(.cheffiGray8)
                            
                            Spacer(minLength: Metrics.headlineTextHorizontalSpacing)
                            
                            Text("3개이상 등록")
                                .font(.custom("SUIT", size: 14))
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
                    } // 사진첨부 영역 끝
                    .padding(.horizontal, Metrics.outsidePadding)
                    .animation(.snappy, value: viewStore.selectedImageDatas.isEmpty)
                    
                    // 리뷰작성 영역
                    VStack(spacing: 0) {
                        Text("제목")
                            .font(.custom("SUIT", size: 14))
                            .foregroundColor(.cheffiGray8)
                            .padding(.top, Metrics.smallHeadlineTextTopPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextFieldBarView(store.scope(
                            state: \.titleTextFieldBarState,
                            action: ReviewComposeReducer.Action.titleTextFieldBarAction
                        ))
                        .padding(.top, Metrics.textFieldTopPadding)
                        
                        TextEditorView(store.scope(
                            state: \.mainTextEditorViewState,
                            action: ReviewComposeReducer.Action.mainTextEditorViewAction
                        ))
                        .frame(height: Metrics.mainTextEditorHeight)
                    } // 리뷰작성 영역 끝
                    .padding(.horizontal, Metrics.outsidePadding)
                    
                    // 메뉴선택 영역
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("어떤 메뉴를 드셨나요?")
                                .font(.custom("SUIT", size: 20).weight(.semibold))
                                .foregroundColor(.cheffiGray8)
                            
                            Spacer(minLength: Metrics.headlineTextHorizontalSpacing)
                            
                            Text("최대 5개 등록")
                                .font(.custom("SUIT", size: 14))
                                .foregroundColor(.cheffiGray5)
                        }
                        .padding(Metrics.headlineTextPadding)
                        
                        Text("드신 메뉴와 가격을 알려주세요")
                            .font(.custom("SUIT", size: 14))
                            .foregroundColor(.cheffiGray6)
                            .padding(Metrics.menuAskingDescriptionTextPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if viewStore.composedMenus.isEmpty {
                            Image(.emptyMenuBackground)
                                .padding(Metrics.menuAskingBackgroundImagePadding)
                        } else {
                            ForEach(viewStore.composedMenus, id: \.self) { menu in
                                HStack(spacing: Metrics.menuItemHStackSpacing) {
                                    Text(menu.name)
                                        .font(.custom("SUIT", size: 16).weight(.medium))
                                        .foregroundColor(.cheffiGray9)
                                    
                                    Spacer()
                                    
                                    Text("\(menu.price)원")
                                        .font(.custom("SUIT", size: 16).weight(.semibold))
                                        .foregroundColor(.cheffiGray9)
                                    
                                    Button {
                                        viewStore.send(.deleteMenuItem(menu))
                                    } label: {
                                        Image(.iconClose)
                                    }
                                }
                                .padding(.top, Metrics.menuItemHStackTopPadding)
                            }
                        }
                        
                        Button {
                            viewStore.send(.tapMenuCompose)
                        } label: {
                            HStack(spacing: Metrics.attatchPhotoButtonContentsSpacing) {
                                if viewStore.composedMenus.isEmpty == false {
                                    Image(.iconPlus)
                                }
                                
                                Text(viewStore.composedMenus.isEmpty ? "메뉴 선택" : "메뉴 추가하기")
                                    .font(.custom("SUIT", size: 16).weight(.medium))
                            }
                            .padding(Metrics.attatchPhotoButtonPadding)
                            .frame(maxWidth: .infinity)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: Metrics.attatchPhotoButtonCornerRadius)
                                .inset(by: 0.5)
                                .stroke(
                                    viewStore.composedMenus.isEmpty ? .cheffiPink1 : .cheffiGray2,
                                    lineWidth: 1
                                )
                        )
                        .padding(.vertical, Metrics.attatchPhotoButtonViewPadding)
                        .foregroundColor(viewStore.composedMenus.isEmpty ? .mainCTA : .cheffiGray7)
                    } // 메뉴선택 영역 끝
                    .padding(.horizontal, Metrics.outsidePadding)
                    .padding(.bottom, viewStore.composedMenus.isEmpty ? 0 : Metrics.menuAreaBottomPadding)
                    .animation(.snappy, value: viewStore.composedMenus)
                    
                    Spacer()
                }
                .scrollDismissesKeyboard(.immediately)
                
                BottomButtonView(store.scope(
                    state: \.bottomButtonState,
                    action: ReviewComposeReducer.Action.bottomButtonAction
                ))
                .padding(.horizontal, Metrics.outsidePadding)
            }
            
            //  메뉴 작성 팝업
            if viewStore.isShowMenuComposePopup {
                RestaurantMenuComposePopupView(store.scope(
                    state: \.menuComposePopupState,
                    action: ReviewComposeReducer.Action.menuComposePopupAction
                ))
            }
            
            // 메뉴 최대갯수 확인 팝업
            if viewStore.isShowMaxMenuConfirmPopup {
                ConfirmPopupView(store.scope(
                    state: \.maxMenuConfirmPopupState,
                    action: ReviewComposeReducer.Action.maxMenuConfirmPopupAction
                ))
            }
        }
        .animation(.default, value: viewStore.isShowMenuComposePopup)
        .animation(.default, value: viewStore.isShowMaxMenuConfirmPopup)
    }
}

struct ReviewComposeView_Preview: PreviewProvider {
    static var previews: some View {
        ReviewComposeView(
            Store(initialState: ReviewComposeReducer.State(
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
                ], 
                isShowMenuComposePopup: false, 
                titleTextFieldBarState: TextFieldBarReducer.State(
                    placeHolder: "기사식당 맛있어요",
                    maxCount: 30
                )
            )) {
                ReviewComposeReducer(
                    useCase: PreviewRestaurantRegistUseCase(),
                    steps: PassthroughSubject<RouteStep, Never>()
                )._printChanges()
            }
        )
    }
}
