import ComposableArchitecture
import SwiftUI

struct HomeFeature: Reducer {

    struct Destination: Reducer, Equatable {
        enum State: Equatable {
            case profile(ProfileFeature.State)
        }

        enum Action: Equatable {
            case profile(ProfileFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.profile, action: /Action.profile) {
                ProfileFeature()
            }
        }
    }

    enum Action: Equatable {
        case onAppear
        case destination(PresentationAction<Destination.Action>)
        case switchTriggered
    }

    struct State: Equatable {
        var title: String = ""
        @PresentationState var destination: Destination.State?
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.destination = .profile(.init())
                return .none

            case .destination(.presented(.profile(.closeActionTriggered))):
                state.destination = nil
                return .none

            case .destination(.dismiss):
                state.destination = nil
                return .none
            case .destination(.presented(.profile)):
                return .none

            case .switchTriggered:
                // handled in content
                return .none
            }
        }
    }
}

struct HomeView: View {
    let store: StoreOf<HomeFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Home screen")
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
            }
            .fullScreenCover(
                store: self.store.scope(
                    state: \.$destination,
                    action: { .destination($0) }
                ),
                state: /HomeFeature.Destination.State.profile,
                action: HomeFeature.Destination.Action.profile
            ) { store in
                ProfileView(store: store)
                    .background(.red)
            }
        }
    }
}
