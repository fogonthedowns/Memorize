//
//  Pie.swift
//  Memorize
//
//  Created by Justin Zollars on 7/10/21.
//

import SwiftUI
    
// Lecture 6
// Shapes can be animated, views can not
struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x:rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
    
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: !clockwise) // not cartisian coordinates, 0,0 is the top left; x increasing is right, y increasing is down
        p.addLine(to: center)
        return p
    }
    
}

