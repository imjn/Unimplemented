//
//  Dependency.swift
//  Unimplemented
//
//  Created by Imajin Kawabe on 20/10/2023.
//

import Dependencies

extension DependencyValues {
    var userService: UserService {
        get { self[UserService.self] }
        set { self[UserService.self] = newValue }
    }
}
