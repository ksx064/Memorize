//
//  Cardify.swift
//  Memorize
//
//  Created by Ken Wang on 2022/5/16.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    init(isFaceUp:Bool){
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{
            rotation
        }
        set{
            rotation = newValue
        }
    }
    
    var  rotation: Double
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius:DrawingConstent.cornerRadius)
            if rotation < 90 {
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth:DrawingConstent.lineWidth)
                
            } else {
                shape
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    struct DrawingConstent {
        static let cornerRadius:CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify (isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
