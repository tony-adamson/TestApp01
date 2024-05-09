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
        VStack(alignment: .leading) {
            
            Image("mainimage")
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Text("Please sign in via email or Google")
                .font(.headline)
                .foregroundStyle(.appDarkGray)
                .padding(.bottom, 16)
            
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
                
                HStack {
                    VStack { Divider() }
                    Text("or")
                        .font(.headline)
                        .foregroundStyle(.appDarkGray)
                    VStack { Divider() }
                }
                
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
        .navigationTitle("Welcome!")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
