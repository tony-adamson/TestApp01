//
//  ImageEditorView.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI

struct ImageEditorView: View {
    @StateObject var model = DrawingViewModel()
    
    var body: some View {
        // Home screen
        ZStack {
            NavigationStack {
                VStack {
                    if let _ = UIImage(data: model.imageData) {
                        DrawingScreen()
                            .environmentObject(model)
                        // setting cancel button if image selected...
                            .toolbar(content: {
                                
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: {
                                        model.cancelImageEditing()
                                    }, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            })
                    } else {
                        // show image picker button
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundStyle(.black)
                                .frame(width: 70, height: 70)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.07),
                                        radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.07),
                                        radius: 5, x: -5, y: -5)
                        })
                    }
                }
                .navigationTitle("Image Editor")
            }
            
            if model.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                // Textfield
                TextField("Type Here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .preferredColorScheme(.dark)
                    .foregroundStyle(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
                // Add button and cancel button
                HStack {
                    Button(action: {
                        // toggling the isAdded
                        model.textBoxes[model.currentIndex].isAdded = true
                        // close the view
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation {
                            model.addNewBox = false
                        }
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                }
                .overlay {
                    HStack(spacing: 15) {
                        // Color picker
                        ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        Button(action: {
                            model.textBoxes[model.currentIndex].isBold.toggle()
                        }) {
                            Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("Ok")))
        })
    }
}

#Preview {
    ImageEditorView()
}
