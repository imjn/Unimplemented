//
//  ContentFeatureTests.swift
//  Unimplemented
//
//  Created by Imajin Kawabe on 20/10/2023.
//

import Combine
import ComposableArchitecture
import Dependencies
@testable import Unimplemented
import XCTest

@MainActor
final class ContentFeatureTests: XCTestCase {
    func test_onAppear() {
        let scheduler = DispatchQueue.test
        let store = TestStore(
            initialState: ContentFeature.State(),
            reducer: { ContentFeature() },
            withDependencies: {
                $0.mainQueue = .init(scheduler)
                $0.userService.userProfile = { Just(UserProfile(name: "Steve")).eraseToAnyPublisher() }
            }
        )

        store.send(.onAppear)
        scheduler.advance()

        store.receive(.userProfileReceived(.success(UserProfile(name: "Steve")))) {
            $0.userProfile = UserProfile(name: "Steve")
        }
    }
}

