//
//  UnimplementedApp.swift
//  Unimplemented
//
//  Created by Imajin Kawabe on 20/10/2023.
//

import SwiftUI

@main
struct UnimplementedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: .init(), reducer: ContentFeature()))
        }
    }
}
