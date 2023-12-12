//
//  ContentView.swift
//  Unimplemented
//
//  Created by Imajin Kawabe on 20/10/2023.
//

import Combine
import ComposableArchitecture
import Dependencies
import SwiftUI

struct ContentFeature: ReducerProtocol {
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.userService) var userService

    struct State: Equatable {
        var userProfile: UserProfile?
        var step: Step = .home(.init())

        enum Step: Equatable {
            case welcome(WelcomeFeature.State)
            case home(HomeFeature.State)
        }
    }

    enum Action: Equatable {
        case onAppear
        case userProfileReceived(Result<UserProfile, Never>)
        case welcome(WelcomeFeature.Action)
        case home(HomeFeature.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.step, action: .self) {
          Scope(state: /State.Step.welcome, action: /Action.welcome) {
            WelcomeFeature()
          }
          Scope(state: /State.Step.home, action: /Action.home) {
            HomeFeature()
          }
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return userService
                    .userProfile()
                    .receive(on: mainQueue)
                    .catchToEffect(ContentFeature.Action.userProfileReceived)
            case .userProfileReceived(.success(let userProfile)):
                state.userProfile = userProfile
                return .none
            case .userProfileReceived(.failure):
                return .none
            case .welcome:
                return .none
            case .home(.destination(.presented(.profile(.closeActionTriggered)))):
                state.step = .welcome(.init())
                return .none
            case .home:
                return .none
            }
        }
    }
}

struct ContentView: View {
    let store: StoreOf<ContentFeature>

    var body: some View {
        SwitchStore(self.store.scope(state: \.step, action: { $0 })) { state in
            switch state {
            case .home:
                CaseLet(/ContentFeature.State.Step.home, action: ContentFeature.Action.home) { store in
                    HomeView(store: store)
                        .background(.blue)
                }
            case .welcome:
                CaseLet(/ContentFeature.State.Step.welcome, action: ContentFeature.Action.welcome) { store in
                    WelcomeView(store: store)
                        .background(.green)
                }
            }
        }
    }
}
