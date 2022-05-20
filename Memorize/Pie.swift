//
//  Pie.swift
//  Memorize
//
//  Created by Ken Wang on 2022/5/16.
//

import SwiftUI

struct Pie: Shape {
    var startAngel: Angle
    var endAngle: Angle
    
    func path(in rect:CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngel.radians)),
            y: center.y + radius * CGFloat(sin(startAngel.radians))
        )
        var p = Path()
        //... draw pie
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngel,
                 endAngle: endAngle,
                 clockwise: true
        )
        p.addLine(to: center)
        return p
    }
}
