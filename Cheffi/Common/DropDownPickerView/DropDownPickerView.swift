//
//  DropDownPickerView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/28/24.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

enum DropDownPickerState {
    case top
    case bottom
}

@ViewStore(DropDownPickerReducer.self)
struct DropDownPickerView: View {
    private enum Policy {
        static let heightMultiply = 5.5
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                
                if viewStore.dropDownPickerState == .top && viewStore.isShowDropdown {
                    optionsView(size: size)
                }
                
                HStack {
                    Text(viewStore.selection == nil ? viewStore.placeHolder : viewStore.selection!)
                        .font(.custom("SUIT", size: 14))
                        .foregroundColor(viewStore.selection != nil ? .cheffiGray9 : .cheffiGray5)
                    
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: viewStore.dropDownPickerState == .top ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundColor(viewStore.isShowDropdown ? .cheffiGray9 : .cheffiGray4)
                        .rotationEffect(.degrees((viewStore.isShowDropdown ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(.white)
                .contentShape(.rect)
                .onTapGesture {
                    return withAnimation(.snappy) {
                        viewStore.send(.toggleDropDown)
                    }
                }
                
                if viewStore.dropDownPickerState == .bottom && viewStore.isShowDropdown {
                    optionsView(size: size)
                }
            }
            .clipped()
            .background(.white)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewStore.isShowDropdown ? .cheffiGray9 : .cheffiGray4)
            }
            .frame(height: size.height, alignment: viewStore.dropDownPickerState == .top ? .bottom : .top)
            
        }
    }
    
    
    func optionsView(size: CGSize) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(viewStore.options, id: \.self) { option in
                    HStack {
                        Text(option)
                            .font(.custom("SUIT", size: 14))
                        Spacer()
                    }
                    .foregroundStyle(.cheffiGray8)
                    .animation(.none, value: viewStore.selection)
                    .contentShape(.rect)
                    .padding(.horizontal, 15)
                    .frame(width: size.width, height: size.height)
                    .background(viewStore.selection == option ? .cheffiGray1 : .cheffiWhite)
                    .onTapGesture {
                        return withAnimation(.snappy) {
                            viewStore.send(.select(option))
                        }
                    }
                }
            }
        }
        .frame(height: min(
            size.height * CGFloat(viewStore.options.count),
            size.height * Policy.heightMultiply
        ))
        .transition(.move(edge: viewStore.dropDownPickerState == .top ? .bottom : .top))
        .zIndex(-10) // 드롭다운이 바닥에 깔리도록
    }
}

struct DropDownPickerView_Preview: PreviewProvider {
    static var previews: some View {
        DropDownPickerView(
            Store(initialState: DropDownPickerReducer.State(
                placeHolder: "광역시 / 도",
                selection: nil,
                options: [
                    "서울특별시",
                    "인천광역시",
                    "부산광역시",
                    "서울특별시",
                    "인천광역시",
                    "부산광역시",
                    "서울특별시",
                    "인천광역시",
                    "부산광역시",
                    "서울특별시",
                    "인천광역시",
                    "부산광역시",
                    "서울특별시",
                    "인천광역시",
                    "부산광역시",
                    "서울특별시",
                    "인천광역시",
                    "부산광역시"
                ]
            )) {
                DropDownPickerReducer()._printChanges()
            }
        )
    }
}
