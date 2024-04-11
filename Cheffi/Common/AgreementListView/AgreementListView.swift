//
//  AgreementListView.swift
//  Cheffi
//
//  Created by ronick on 2024/04/06.
//

import SwiftUI
import ComposableArchitecture
import ViewStore

enum Term: Int, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case age
    case useOfService
    case privateInfo
    case location
    case marketing

    func termTitle() -> String {
        switch self {
        case .age:
            return "[필수] 만 14세 이상입니다."
        case .useOfService:
            return "[필수] 서비스 이용 약관 동의"
        case .privateInfo:
            return "[필수] 개인정보 수집 및 이용 동의"
        case .location:
            return "[필수] 위치정보 이용동의 및 위치기반서비스 이용 동의"
        case .marketing:
            return "[선택] 마케팅 정보 수신 동의"
        }
    }
}

@ViewStore(AgreementListViewReducer.self)
struct AgreementListView: View {
    private enum Metrics {
        static let barPaddingEdgeInsets = EdgeInsets(top: 20.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        static let barHeight = 40.0
        static let barCornerRadius = 6.0
    }

    var body: some View {
        LazyVStack(spacing: 4) {
            ForEach(Term.allCases) { term in
                HStack {
                    Button {
                        viewStore.send(.input(term))
                    } label: {
                        if viewStore.isConsented[term]! {
                            Image("icCheck")
                                .renderingMode(.original)
                                .tint(.cheffiGray2)
                        } else {
                            Image("icUncheck")
                                .renderingMode(.original)
                                .tint(.cheffiGray2)
                        }
                    }
                    .padding(10)
                    
                    Text(term.termTitle())
                        .multilineTextAlignment(.leading)
                        .font(
                            Font.custom("SUIT", size: 15)
                                .weight(.regular)
                        )
                        .foregroundStyle(.cheffiGray9)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Button {
                        // TODO: 액션 이벤트
                    } label: {
                        Image("icMoreRight")
                            .renderingMode(.template)
                            .tint(.cheffiGray4)
                    }
                }
                .padding([.top, .bottom], 12)
            }
        }
    }
}

struct AgreementListView_Previews: PreviewProvider {
    static var previews: some View {
        AgreementListView(
            Store(initialState: AgreementListViewReducer.State()) {
                AgreementListViewReducer()._printChanges()
            }
        )
    }
}
