//
//  DrawingScreen.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                
                let size = proxy.frame(in: .local)
                
                DispatchQueue.main.async {
                    if model.rect == .zero {
                        model.rect = size
                    }
                }

                return AnyView(
                    ZStack {
                        // UIKit pencil kit drawing view
                        CanvasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
                        
                        // custom text
                        
                        // displaying text boxes
                        ForEach(model.textBoxes) { box in
                            Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                                .font(.system(size: 30))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundStyle(box.textColor)
                                .offset(box.offset)
                            // drag gesture
                                .gesture(DragGesture().onChanged({ (value) in
                                    let current = value.translation
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                    
                                    model.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                }).onEnded({ (value) in
                                    // saving new position
                                    model.textBoxes[getIndex(textBox: box)].lastOffset = value.translation
                                }))
                            //editing the typed one
                                .onLongPressGesture {
                                    // closing the toolbar
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textBox: box)
                                    withAnimation {
                                        model.addNewBox = true
                                    }
                                }
                        }
                    }
                )
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: model.saveImage, label: {
                    Text("Save")
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // create new text box
                    model.textBoxes.append(TextBox())
                    
                    // updating index
                    model.currentIndex = model.textBoxes.count - 1
                    
                    withAnimation {
                        model.addNewBox.toggle()
                    }
                    // Close toolBar
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
    }
    
    func getIndex(textBox: TextBox) -> Int {
        let index = model.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
}

struct CanvasView: UIViewRepresentable {
    
    //since we need to get the drawings so were binding...
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    
    // view size
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        //appending the image in canvassubview
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            print("ImageView frame set to: \(imageView.frame)")
            print("Size from GeometryReader: \(rect.width)")
            imageView.clipsToBounds = true
            
            //basically were setting image to the back of the canvas...
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            //showing tool picker
            //were setting it as first responder and making it as visible
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update UI will update for eacj actions...
        
    }
}
