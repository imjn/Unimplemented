//
//  UserService.swift
//  Unimplemented
//
//  Created by Imajin Kawabe on 20/10/2023.
//

import Combine
import Dependencies
import XCTestDynamicOverlay

struct UserService {
    var userProfile: () -> AnyPublisher<UserProfile, Never>
}

extension UserService: DependencyKey {
    static let liveValue: UserService = .init(
        userProfile: { fatalError("Not used in this project") }
    )
}

extension UserService: TestDependencyKey {
    static let previewValue: UserService = .init(
        userProfile: { Just(UserProfile(name: "Tim")).eraseToAnyPublisher() }
    )

    static let testValue: UserService = .init(
        userProfile: unimplemented(
            "\(Self.self).userProfile",
            placeholder: Self.previewValue.userProfile // When I don't set this placeholder, the test succeeds.
        )
    )
}
