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
    }

    enum Action: Equatable {
        case onAppear
        case userProfileReceived(Result<UserProfile, Never>)
    }

    var body: some ReducerProtocol<State, Action> {
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
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
