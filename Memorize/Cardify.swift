//
//  Cardify.swift
//  Memorize
//
//  Created by Ken Wang on 2022/5/16.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius:DrawingConstent.cornerRadius)
            if isFaceUp {
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth:DrawingConstent.lineWidth)
                
            } else {
                shape
            }
            content
                .opacity(isFaceUp ? 1 : 0)
        }
    }
    struct DrawingConstent {
        static let cornerRadius:CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}
