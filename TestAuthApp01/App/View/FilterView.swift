//
//  FilterView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel
    @State private var selectedImage: UIImage?
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            // Big image
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .appMint))
                    .scaleEffect(3)
                    .zIndex(1)
                
                Spacer()
            } else {
                Group {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                    } else if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width)
                .padding(.bottom, 16)
            }
            
            // Additional text
            Text("Please choose filter")
                .foregroundStyle(.yellow)
                .font(.title2)
                .padding(.bottom, 16)
            
            // Row with filters
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.generatePreviews(for: viewModel.selectedImage!), id: \.self) { img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 100)
                            .onTapGesture {
                                self.isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.selectedImage = img
                                    self.isLoading = false
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 16)
            
            // Button
            Button(action: {
                viewModel.selectedImage = selectedImage
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Set Filter")
                    .font(.headline)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.appBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
        }
        .padding()
        .foregroundStyle(.white)
    }
}
