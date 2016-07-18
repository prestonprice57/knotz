//
//  Line.swift
//  BrickBreak
//
//  Created by Preston Price on 1/3/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import SpriteKit

class Line: NSObject {
    var lineStart: CGPoint
    var lineEnd: CGPoint
    var lineCoordinates: [CGPoint]
    var lineShape: SKShapeNode = SKShapeNode()
    var path = CGMutablePath()
    var hasCollision = 0
    
    init(lineStart: CGPoint, lineEnd: CGPoint) {
        self.lineStart = lineStart
        self.lineEnd = lineEnd
        self.lineCoordinates = [lineStart, lineEnd]
    }

    
}
