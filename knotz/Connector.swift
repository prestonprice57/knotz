//
//  Connector.swift
//  BrickBreak
//
//  Created by Preston Price on 1/3/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import Foundation
import SpriteKit

class Connector: NSObject {
    var circle: SKShapeNode
    var circleTouchArea: SKShapeNode
    var lineIn: Line
    var lineOut: Line
    
    init(circle: SKShapeNode, circleTouchArea: SKShapeNode, lineIn: Line, lineOut: Line) {
        self.circle = circle
        self.circleTouchArea = circleTouchArea
        self.lineIn = lineIn
        self.lineOut = lineOut
    }
}