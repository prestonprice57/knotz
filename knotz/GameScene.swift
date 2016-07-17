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
            viewController!.movesLeft.text = String(movesAllowed!)
        }
    }
    
    func loadLevel(_ levelNumber: Int) {
        self.removeAllActions()
        self.removeAllChildren()
        
        self.level = levelNumber
        
        if levelNumber == 1 {
            viewController!.label1.isHidden = false
            viewController!.label2.isHidden = false
        } else {
            viewController!.label1.isHidden = true
            viewController!.label2.isHidden = true
        }
        
        let destinationFile = "level\(levelNumber)"
        if let filepath = Bundle.main().pathForResource(destinationFile, ofType: "txt") {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                let coordinateArray = contents.components(separatedBy: "\n")
                
                for (i, num) in coordinateArray.enumerated() {
                    
                    if i < coordinateArray.count-1 {
                        let points = num.components(separatedBy: " ")
                    
                        if let x = NumberFormatter().number(from: points[0]) {
                            if let y = NumberFormatter().number(from: points[1]) {
                                let xFloat = CGFloat(x)*self.screenWidth
                                let yFloat = CGFloat(y)*self.screenHeight
                                self.coordinates.append(CGPoint(x: xFloat, y: yFloat))
                            }
                        }
                    } else {
                        starCount = num.components(separatedBy: " ")
                        
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
    
    override func didMove(to view: SKView) {
        
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
    
    func drawLine(_ line: Line) {
        line.path.moveTo(nil, x: line.lineStart.x, y: line.lineStart.y)
        line.path.addLineTo(nil, x: line.lineEnd.x, y: line.lineEnd.y)
        line.lineShape.path = line.path
        line.lineShape.lineWidth = 7
        line.lineShape.strokeColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0, alpha: 1.0)
        
        self.addChild(line.lineShape)
    }
    
    func drawConnector(_ connector: Connector, connectorNumber: String) {
        connector.circle = SKShapeNode(circleOfRadius: 10)
        connector.circleTouchArea = SKShapeNode(circleOfRadius: 25)
        
        drawLine(connector.lineOut)
        connector.circle.position = CGPoint(x: connector.lineIn.lineEnd.x, y: connector.lineIn.lineEnd.y)
        connector.circle.fillColor = UIColor.white()
        connector.circle.zPosition = 100
        connector.circle.name = "circle" + connectorNumber
        connector.circle.strokeColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0, alpha: 1.0)
        
        connector.circleTouchArea.position = connector.circle.position
        connector.circleTouchArea.fillColor = UIColor.clear()
        connector.circleTouchArea.name = "circle" + connectorNumber
        connector.circleTouchArea.strokeColor = UIColor.clear()
        
        self.addChild(connector.circle)
        self.addChild(connector.circleTouchArea)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if let nodeName = node.name {
                if nodeName.contains("circle") == true {
                    if let lastIndex = Int(nodeName.substring(from: nodeName.characters.index(nodeName.startIndex, offsetBy: 6))) {
                        currentConnectorPressed = lastIndex
                        touchesStarted = true
                        circleTouched = true
                        moveConnector(connectors[currentConnectorPressed], currentLocation: location)
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchesStarted == true {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            moveConnector(connectors[currentConnectorPressed], currentLocation: location)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesStarted = false
        checkForCollision()
        
        circleTouched = false
    }
    
    func moveConnector(_ connector: Connector, currentLocation: CGPoint) {
        
        let newLineInPath = CGMutablePath()
        newLineInPath.moveTo(nil, x: connector.lineIn.lineStart.x, y: connector.lineIn.lineStart.y)
        newLineInPath.addLineTo(nil, x: currentLocation.x, y: currentLocation.y)
        connector.lineIn.lineShape.path = newLineInPath
        connector.lineIn.lineEnd = CGPoint(x: currentLocation.x, y: currentLocation.y)
        
        let newLineOutPath = CGMutablePath()
        newLineOutPath.moveTo(nil, x: currentLocation.x, y: currentLocation.y)
        newLineOutPath.addLineTo(nil, x: connector.lineOut.lineEnd.x, y: connector.lineOut.lineEnd.y)
        connector.lineOut.lineShape.path = newLineOutPath
        connector.lineOut.lineStart = CGPoint(x: currentLocation.x, y: currentLocation.y)
        
        connector.circle.position = CGPoint(x: currentLocation.x, y: currentLocation.y)
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
                        collisions += 1
                        line.hasCollision += 1
                        line2.hasCollision += 1
                    }
                }
            }
        }
        
        for line in lines {
            if line.hasCollision > 0 {
                let redColor = UIColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1.0)
                line.lineShape.strokeColor = redColor
            } else {
                let blueColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0, alpha: 1.0)
                line.lineShape.strokeColor = blueColor
            }
            line.hasCollision = 0
        }
        
        if collisions == 0 {
            // game completed
            let seconds = 0.7
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            
            //DispatchQueue.main.after(when: dispatchTime, execute: {
                
            self.viewController!.performSegue(withIdentifier: "gameEnded", sender: self)
            let endGame = self.viewController!.presentedViewController as! EndGameViewController
            
            endGame.level = self.level+1
            self.level+=1
            endGame.stars = self.determineStars()
            //})
        }
        
        if circleTouched == true {
            movesAllowed! -= 1
        }
        
        if movesAllowed <= 0 {
            
            let seconds = 0.7
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            
            //DispatchQueue.main.after(when: dispatchTime, execute: {
            self.viewController!.performSegue(withIdentifier: "gameOver", sender: self)
                
                
                /*dispatch_after(dispatchTime2, dispatch_get_main_queue(), {
                    self.restartLevel(self.level)
                })*/
            //})
            
            
        }
    }
    
    func restartLevel(_ level: Int) {
        coordinates = []
        lines = []
        connectors = []
        
        self.removeAllActions()
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
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
}
