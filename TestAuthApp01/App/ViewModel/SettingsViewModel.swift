//
//  SettingsViewModel.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
                
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    //TODO: Realise this function if needed
    func updateEmail() async throws {
        let email = "test3@test.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    //TODO: Realise this function if needed
    func updatePassword() async throws {
        let password = "654321"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}
