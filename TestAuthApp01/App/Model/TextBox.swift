//
//  TextBox.swift
//  TestAuthApp01
//
//  Created by Антон Адамсон on 09.05.2024.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    // For Dragging the view over the screen
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    // TODO: Add additional property here if nedeed
    var isAdded: Bool = false
}
