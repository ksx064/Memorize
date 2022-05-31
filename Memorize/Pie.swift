//
//  Pie.swift
//  Memorize
//
//  Created by Ken Wang on 2022/5/16.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    var animatabledata: AnimatablePair<Double,Double> {
        get{
            AnimatablePair(startAngle.degrees, endAngle.degrees)
        }
        set{
            startAngle = Angle.degrees(newValue.first)
            endAngle = Angle.degrees(newValue.second)
        }
    }
    
    func path(in rect:CGRect) -> Path {
        if startAngle.degrees == endAngle.degrees {
            return Circle().path(in: rect)
        }
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        var p = Path()
        //... draw pie
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: true
        )
        p.addLine(to: center)
        return p
    }
}
