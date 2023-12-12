import ComposableArchitecture
import SwiftUI

struct WelcomeFeature: Reducer {
    enum Action: Equatable {
        case onAppear
    }

    struct State: Equatable {
        var title: String = ""
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct WelcomeView: View {
    let store: StoreOf<WelcomeFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("Welcome screen")
        }
    }
}
