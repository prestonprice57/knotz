//
//  GameScene.swift
//  BrickBreak
//
//  Created by Preston Price on 12/17/15.
//  Copyright (c) 2015 prestonwprice. All rights reserved.
//

import SpriteKit

enum ShapeType: UInt32 {
    case line = 1
    case circle = 2
}

class GameScene: SKScene {
    
    var viewController: GameViewController?

    var coordinates = [CGPoint]()
    var lines = [Line]()
    var connectors = [Connector]()
    var touchesStarted = false
    var circleTouched = false
    var currentConnectorPressed = Int()
    var level = 0
    var levelCompleted = false
    var screenHeight: CGFloat! //These are both set in GameViewController
    var screenWidth: CGFloat!  // 
    var starCount: [String]!
    var movesAllowed: Int! {
        didSet {
            viewController!.movesLeft.text = String(movesAllowed)
        }
    }
    
    func loadLevel(levelNumber: Int) {
        let destinationFile = "level\(levelNumber)"
        if let filepath = NSBundle.mainBundle().pathForResource(destinationFile, ofType: "txt") {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                let coordinateArray = contents.componentsSeparatedByString("\n")
                
                for (i, num) in coordinateArray.enumerate() {
                    
                    if i < coordinateArray.count-1 {
                        let points = num.componentsSeparatedByString(" ")
                    
                        if let x = NSNumberFormatter().numberFromString(points[0]) {
                            if let y = NSNumberFormatter().numberFromString(points[1]) {
                                let xFloat = CGFloat(x)*self.screenWidth
                                let yFloat = CGFloat(y)*self.screenHeight
                                self.coordinates.append(CGPointMake(xFloat, yFloat))
                            }
                        }
                    } else {
                        starCount = num.componentsSeparatedByString(" ")
                        
                        movesAllowed = Int(starCount[0])
                        
                    }
                    
                    
                }
            } catch {
                // contents could not be loaded
                print("Contents could not be loaded")
            }
        } else {
            // example.txt not found!
            print("Level not found")
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        loadLevel(level)
        
        for i in 0..<coordinates.count {
            if i < coordinates.count-1 {
                let line = Line(lineStart: coordinates[i], lineEnd: coordinates[i+1])
                
                lines.append(line)
            } else {
                let line = Line(lineStart: coordinates[i], lineEnd: coordinates[0])
                lines.append(line)
            }
        }
        
        for i in 0..<lines.count {
            let circle = SKShapeNode()
            let circleTouchArea = SKShapeNode()
            
            if i < lines.count-1 {
                let connector = Connector(circle: circle, circleTouchArea: circleTouchArea, lineIn: lines[i], lineOut: lines[i+1])
                connectors.append(connector)
            } else {
                let connector = Connector(circle: circle, circleTouchArea: circleTouchArea, lineIn: lines[i], lineOut: lines[0])
                connectors.append(connector)
            }
        }
        
        for i in 0..<connectors.count {
            drawConnector(connectors[i], connectorNumber: String(i))
        }
        checkForCollision()
    }
    
    func drawLine(line: Line) {
        CGPathMoveToPoint(line.path, nil, line.lineStart.x, line.lineStart.y)
        CGPathAddLineToPoint(line.path, nil, line.lineEnd.x, line.lineEnd.y)
        line.lineShape.path = line.path
        line.lineShape.lineWidth = 7
        line.lineShape.strokeColor = UIColor.blackColor()
        
        self.addChild(line.lineShape)
    }
    
    func drawConnector(connector: Connector, connectorNumber: String) {
        connector.circle = SKShapeNode(circleOfRadius: 10)
        connector.circleTouchArea = SKShapeNode(circleOfRadius: 20)
        
        drawLine(connector.lineOut)
        connector.circle.position = CGPointMake(connector.lineIn.lineEnd.x, connector.lineIn.lineEnd.y)
        connector.circle.fillColor = UIColor.whiteColor()
        connector.circle.zPosition = 100
        connector.circle.name = "circle" + connectorNumber
        connector.circle.strokeColor = UIColor.blackColor()
        
        connector.circleTouchArea.position = connector.circle.position
        connector.circleTouchArea.fillColor = UIColor.clearColor()
        connector.circleTouchArea.name = "circle" + connectorNumber
        connector.circleTouchArea.strokeColor = UIColor.clearColor()
        
        self.addChild(connector.circle)
        self.addChild(connector.circleTouchArea)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.locationInNode(self)
        
        let nodes = nodesAtPoint(location)
        
        for node in nodes {
            if let nodeName = node.name {
                if nodeName.containsString("circle") == true {
                    if let lastIndex = Int(nodeName.substringFromIndex(nodeName.startIndex.advancedBy(6))) {
                        currentConnectorPressed = lastIndex
                        touchesStarted = true
                        circleTouched = true
                        moveConnector(connectors[currentConnectorPressed], currentLocation: location)
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchesStarted == true {
            guard let touch = touches.first else { return }
            let location = touch.locationInNode(self)
            
            moveConnector(connectors[currentConnectorPressed], currentLocation: location)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesStarted = false
        checkForCollision()
        
        circleTouched = false
    }
    
    func moveConnector(connector: Connector, currentLocation: CGPoint) {
        
        let newLineInPath = CGPathCreateMutable()
        CGPathMoveToPoint(newLineInPath, nil, connector.lineIn.lineStart.x, connector.lineIn.lineStart.y)
        CGPathAddLineToPoint(newLineInPath, nil, currentLocation.x, currentLocation.y)
        connector.lineIn.lineShape.path = newLineInPath
        connector.lineIn.lineEnd = CGPointMake(currentLocation.x, currentLocation.y)
        
        let newLineOutPath = CGPathCreateMutable()
        CGPathMoveToPoint(newLineOutPath, nil, currentLocation.x, currentLocation.y)
        CGPathAddLineToPoint(newLineOutPath, nil, connector.lineOut.lineEnd.x, connector.lineOut.lineEnd.y)
        connector.lineOut.lineShape.path = newLineOutPath
        connector.lineOut.lineStart = CGPointMake(currentLocation.x, currentLocation.y)
        
        connector.circle.position = CGPointMake(currentLocation.x, currentLocation.y)
        connector.circleTouchArea.position = connector.circle.position
    
    }
    
    func checkForCollision() {
        var collisions = 0
        
        for line in lines {
            for line2 in lines {
                let point1 = line.lineStart
                let point2 = line.lineEnd
                let point3 = line2.lineStart
                let point4 = line2.lineEnd
                
                if line2.lineStart != line.lineStart && line2.lineEnd != line.lineEnd && line.lineStart != line2.lineEnd && line2.lineStart != line.lineEnd && line2.lineEnd != line.lineStart && line.lineEnd != line2.lineStart{
                    
                    var m1: CGFloat!
                    var b1: CGFloat!
                    
                    var m2: CGFloat!
                    var b2: CGFloat!
                    
                    var line1Vertical = false
                    var line2Vertical = false
                    
                    if point2.x != point1.x {
                        m1 = (point2.y-point1.y)/(point2.x-point1.x)
                        b1 = point1.y - (m1*point1.x)
                    } else {
                        m1 = (point2.y-point1.y)/((point2.x-point1.x)+0.0000001)
                        b1 = point1.y - (m1*point1.x)
                        line1Vertical = true
                    }
                    
                    if point3.x != point4.x {
                        m2 = (point4.y-point3.y)/(point4.x-point3.x)
                        b2 = point3.y - (m2*point3.x)
                    } else {
                        m2 = (point4.y-point3.y)/((point4.x-point3.x)+0.0000001)
                        b2 = point3.y - (m2*point3.x)
                        line2Vertical = true
                    }
                    
                    let x: CGFloat
                    let y: CGFloat
                    
                    if line1Vertical == true && line2Vertical == true {
                        x = 1000000.0 // Pretty crappy hack to show they are parrallel and will never touch
                        y = 1000000.0
                    } else if line1Vertical == true {
                        x = point1.x
                        y = (m2*x)+b2
                    } else if line2Vertical == true {
                        x = point3.x
                        y = (m1*x)+b1
                    } else {
                        x = (b2-b1)/(m1-m2)
                        y = (m1*x)+b1
                    }
                    
                    if x >= min(point1.x, point2.x) && x >= min(point3.x, point4.x) && x <= max(point1.x, point2.x) && x <= max(point3.x, point4.x) && y >= min(point1.y, point2.y) && y >= min(point3.y, point4.y) && y <= max(point1.y, point2.y) && y <= max(point3.y, point4.y){
                        collisions++
                        line.hasCollision++
                        line2.hasCollision++
                    }
                }
            }
        }
        
        for line in lines {
            if line.hasCollision > 0 {
                let redColor = UIColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1.0)
                line.lineShape.strokeColor = redColor
            } else {
                let greenColor = UIColor(red: 200/256, green: 247/256, blue: 197/256, alpha: 1.0)
                line.lineShape.strokeColor = greenColor
            }
            line.hasCollision = 0
        }
        
        if collisions == 0 {
            // game completed
            let seconds = 2.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                self.viewController!.performSegueWithIdentifier("gameEnded", sender: self)
                
            })
        }
        
        if circleTouched == true {
            movesAllowed!--
        }
        
        if movesAllowed <= 0 {
            
            let seconds = 2.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.viewController!.performSegueWithIdentifier("gameOver", sender: self)
                self.restartLevel(self.level)
            })
            
            
        }
    }
    
    func restartLevel(level: Int) {
        coordinates = []
        lines = []
        connectors = []
        
        self.removeAllChildren()
        
        loadLevel(level)
        
        for i in 0..<coordinates.count {
            if i < coordinates.count-1 {
                let line = Line(lineStart: coordinates[i], lineEnd: coordinates[i+1])
                
                lines.append(line)
            } else {
                let line = Line(lineStart: coordinates[i], lineEnd: coordinates[0])
                lines.append(line)
            }
        }
        
        for i in 0..<lines.count {
            let circle = SKShapeNode()
            let circleTouchArea = SKShapeNode()
            
            if i < lines.count-1 {
                let connector = Connector(circle: circle, circleTouchArea: circleTouchArea, lineIn: lines[i], lineOut: lines[i+1])
                connectors.append(connector)
            } else {
                let connector = Connector(circle: circle, circleTouchArea: circleTouchArea, lineIn: lines[i], lineOut: lines[0])
                connectors.append(connector)
            }
        }
        
        for i in 0..<connectors.count {
            drawConnector(connectors[i], connectorNumber: String(i))
        }
        checkForCollision()
    }
    
    func determineStars() -> Int {
        let movesMade = Int(starCount[0])! - movesAllowed
        
        var starNumber = 1
        if movesMade <= Int(starCount[2])! {
            starNumber = 3
        } else if movesMade <= Int(starCount[1])! {
            starNumber = 2
        }
        
        return starNumber
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
