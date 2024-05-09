//
//  RootView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 06.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                TabView {
                    PhotoFilterView()
                        .tabItem { Label("Filter", systemImage: "camera.filters") }
                    
                    ImageEditorView()
                        .tabItem { Label("Draw!", systemImage: "paintbrush") }
                    
                    SettingsView(showSignInView: $showSignInView)
                        .tabItem { Label("Settings", systemImage: "gear") }
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser() 
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
