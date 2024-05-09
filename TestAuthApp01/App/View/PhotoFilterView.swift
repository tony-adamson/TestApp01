//
//  PhotoPickerView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct PhotoFilterView: View {
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Image
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    NavigationLink(destination: FilterView(viewModel: viewModel)) {
                        Text("Add Filter")
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(.appLightViolet)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.bottom, 16)
                } else {
                    VStack {
                        Spacer()
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                            .foregroundStyle(.gray.opacity(0.3))
                        Spacer()
                    }
                }
                
                // Button to call photo picker
                PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                    Text("Add image to edit")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("Photo Filter")
        .padding()
        .toolbar(content: {
            // Save button
            // TODO: Add alert
            Button(action: {
                viewModel.saveImageToGallery()
            }, label: {
                Text("Save")
            })
            
            // Cancel button and clear view
            Button(action: {
                viewModel.selectedImage = nil
            }, label: {
                Text("Cancel")
            })
        })
        
    }
}


#Preview {
    PhotoFilterView()
}
