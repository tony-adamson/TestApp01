//
//  TestAuthApp01App.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 06.05.2024.
//

import SwiftUI
import FirebaseCore

@main
struct TestAuthApp01App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
