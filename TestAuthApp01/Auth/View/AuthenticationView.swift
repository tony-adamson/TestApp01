//
//  AuthenticationView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 06.05.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Image
            Image("mainimage")
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            // Text
            Text("Please sign in via email or Google")
                .font(.headline)
                .foregroundStyle(.appDarkGray)
                .padding(.bottom, 16)
            
            // Registration block
            VStack(spacing: 16) {
                
                // Email Button
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
                
                // Spacer
                HStack {
                    VStack { Divider() }
                    Text("or")
                        .font(.headline)
                        .foregroundStyle(.appDarkGray)
                    VStack { Divider() }
                }
                
                // Google Button
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
