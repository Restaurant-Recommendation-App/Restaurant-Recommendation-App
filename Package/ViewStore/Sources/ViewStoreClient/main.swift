import ViewStore
import SwiftUI
import Combine
import ComposableArchitecture

struct SomeReducer: Reducer {
    struct State: Equatable {}
    enum Action {}
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        
    }
}

@ViewStore(SomeReducer.self)
struct SomeView: View {
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("")
        }
    }
}

#Preview {
    SomeView(
        Store(initialState: SomeReducer.State()) {
            SomeReducer()
        }
    )
}
