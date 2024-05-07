//
//  AuthenticationView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 06.05.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
}

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Text("Please sign in via email or Google")
            VStack(spacing: 16) {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign in with email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.appBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                //TODO: Need customization
                //                GoogleSignInButton(viewModel:
                //                                    GoogleSignInButtonViewModel(
                //                                        scheme: .light,
                //                                        style: .wide,
                //                                        state: .normal
                //                                    )
                //                )
                
                
                SignInWithGoogleButtonView {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("Welcome, user!")
        .background(.appBlack)
        .foregroundStyle(.white)
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
