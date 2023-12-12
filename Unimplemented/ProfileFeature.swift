import ComposableArchitecture
import SwiftUI

struct ProfileFeature: Reducer {
    enum Action: Equatable {
        case onAppear
        case closeActionTriggered
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

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Profile screen")
                Button("Switch") {
                    viewStore.send(.closeActionTriggered)
                }
            }            
        }
    }
}
