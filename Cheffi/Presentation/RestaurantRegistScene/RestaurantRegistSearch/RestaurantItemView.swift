//
//  RestaurantItemView.swift
//  Cheffi
//
//  Created by 김문옥 on 1/5/24.
//

import SwiftUI

struct RestaurantItemView: View {
    private enum Metrics {
        static let itemHeight = 72.0
        static let horizontalPadding = 16.0
        static let spacerHeight = 12.0
    }
    
    let restaurant: RestaurantInfoDTO
    let highlightKeyword: String?
    let itemWidth: CGFloat
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    let text = highlightKeyword == nil 
                    ? Text(restaurant.name)
                    : restaurant.name.highlightedText(keyword: highlightKeyword ?? "")
                    
                    text
                        .font(.custom("SUIT", size: 16).weight(.medium))
                        .foregroundColor(.cheffiGray8)
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: Metrics.spacerHeight)
                
                HStack {
                    Text("\(restaurant.address.province) \(restaurant.address.city) \(restaurant.address.roadName) \(restaurant.address.fullRodNameAddress)")
                        .font(
                            Font.custom("SUIT", size: 14)
                                .weight(.medium)
                        )
                        .foregroundColor(.cheffiGray5)
                    
                    Spacer()
                }
            }
        }
        .frame(idealWidth: itemWidth, maxWidth: itemWidth, idealHeight: Metrics.itemHeight, maxHeight: Metrics.itemHeight)
        .padding(.horizontal, Metrics.horizontalPadding)
    }
}

#Preview {
    RestaurantItemView(
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
        highlightKeyword: "사식",
        itemWidth: .infinity
    )
}
