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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .padding(.top, 25)
            } else {
                Image(uiImage: viewModel.selectedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .padding(.top, 25)
            }
            
            Text("Please choose filter")
                .foregroundStyle(.yellow)
                .font(.title2)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.generatePreviews(for: viewModel.selectedImage!), id: \.self) { img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100)
                            .onTapGesture {
                                self.selectedImage = img
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 25)
            
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
        .background(.black)
        .foregroundStyle(.white)
    }
}
