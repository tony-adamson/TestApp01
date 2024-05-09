//
//  DrawingViewModel.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import Foundation

import SwiftUI
import PencilKit

// it holds all our drawing data

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    
    // canvas for drawing...
    @Published var canvas = PKCanvasView()
    // Tool picker
    @Published var toolPicker = PKToolPicker()
    
    // List of TextBoxes...
    @Published var textBoxes: [TextBox] = []
    
    @Published var addNewBox = false
    
    // Current index
    @Published var currentIndex: Int = 0
    
    // Saving the view frame size
    @Published var rect: CGRect = .zero
    
    // Alert
    @Published var showAlert = false
    @Published var message = ""
    
    // cancel function
    func cancelImageEditing() {
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    // Close text view
    func cancelTextView() {
        
        // showing again toolbar
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            addNewBox = false
        }
        
        // removing if cancelled
        // avoiding the removal of already added
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }
    }
    
    func saveImage() {
        // generating image from canvas and textbox view
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        // canvas
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        // drawing text boxes
        let SwitUIView = ZStack {
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundStyle(box.textColor)
                    .offset(box.offset)
            }
        }
        
        let controller = UIHostingController(rootView: SwitUIView).view!
        controller.frame = rect
        
        // clering background
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        // getting image
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // ending render
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData() {
            // saving image as PNG
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            self.message = "Saved Succefully"
            self.showAlert.toggle()
        }
    }
}
