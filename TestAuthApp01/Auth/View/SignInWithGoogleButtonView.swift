//
//  SignInWithGoogleButtonView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 07.05.2024.
//

import SwiftUI

struct SignInWithGoogleButtonView: View {
    var action: () -> Void
        
    var body: some View {
        Button(action: action) {
            HStack {
                Image("google-logo")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.white)
                    
                Text("Sign in with Google")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.appRed)
            .cornerRadius(10)
        }
    }
}


#Preview {
    SignInWithGoogleButtonView(action: {})
}
