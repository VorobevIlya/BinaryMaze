//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 10.07.2021.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum BitMaskCategories: UInt32 {
    case ball   = 0b0001
    case wall   = 0b0010
    case gate   = 0b0100
    case paddle = 0b1000
}

class GameScene: SKScene {
    
    let gatePinName = "GatePin"
    let mazeName = "Maze"
    let paddlePinName = "PaddlePin"
    
    var motionManager: CMMotionManager!
    var gravityFactor: Double = 10
    
    var gate: GateNode!
    
    var firstLayer = [PaddleNode]()
    var secondLayer = [PaddleNode]()
    var thirdLayer = [PaddleNode]()
    var fourthLayer = [PaddleNode]()
    
    var colors = [UIColor]()
    var marbles = [MarbleNode]()
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        createMaze()
        createGate()
        createFirstLayer()
        createSecondLayer()
        createThirdLayer()
        createFourthLayer()
        createResetButton()
        
        for i in 0 ..< 16 {
            colors.append(UIColor(hue: CGFloat(i) / 16.0, saturation: i % 2 == 0 ? 0.65 : 1, brightness: i % 3 == 0 ? 0.65 : 1, alpha: 1))
            createCell(color: colors[i], position: CGPoint(x: CGFloat(i * 35 - 262), y: -348.5), number: 15 - i)
        }
        
        reset()
    }
    
    func reset() {
        if !marbles.isEmpty {
            marbles.forEach({ $0.removeFromParent() })
            marbles.removeAll(keepingCapacity: true)
        }
        
        for (index, color) in colors.shuffled().enumerated() {
            createBall(of: color, at: CGPoint(x: index * 35 - 262, y: 370))
        }
        for (index, color) in colors.shuffled().enumerated() {
            createBall(of: color, at: CGPoint(x: index * 35 - 262, y: 340))
        }
    }
    
    func createResetButton() {
        let button = ButtonNode(label: "RESET")
        button.delegate = self
        button.position = CGPoint(x: 440, y: 340)
        button.zPosition = 1
        
        addChild(button)
    }
    
    func createMaze() {
        let mazeTexture = SKTexture(imageNamed: mazeName)
        let maze = SKSpriteNode(texture: mazeTexture)
        maze.physicsBody = SKPhysicsBody(texture: mazeTexture, size: maze.size)
        maze.physicsBody?.categoryBitMask = BitMaskCategories.wall.rawValue
        maze.physicsBody?.collisionBitMask = BitMaskCategories.ball.rawValue
        maze.physicsBody?.isDynamic = false
        addChild(maze)
    }
    
    func createGate() {
        gate = GateNode()
        gate.position = CGPoint(x: 18, y: 206.5)
        
        addChild(gate)
        
        createPin(named: gatePinName, imageName: gatePinName, atLocation: CGPoint(x: -400, y: 206.5), base: .right)
    }
    
    func createFirstLayer() {
        let paddle = PaddleNode()
        paddle.position = CGPoint(x: 0.5, y: 138.5)
        paddle.zPosition = 1
        addChild(paddle)
        firstLayer.append(paddle)
        
        createPin(named: "firstLayerPin", imageName: paddlePinName, atLocation: CGPoint(x: 400, y: 138.5))
    }
    
    func createSecondLayer() {
        for i in 0 ... 1 {
            let paddle = PaddleNode()
            paddle.position = CGPoint(x: CGFloat(280 * i) - 139.5, y: -1.5)
            paddle.zPosition = 1
            addChild(paddle)
            secondLayer.append(paddle)
        }
        
        createPin(named: "secondLayerPin", imageName: paddlePinName, atLocation: CGPoint(x: 400, y: -1.5))
    }
    
    func createThirdLayer() {
        for i in 0 ... 3 {
            let paddle = PaddleNode()
            paddle.position = CGPoint(x: CGFloat(140 * i) - 209.5, y: -156.5)
            paddle.zPosition = 1
            addChild(paddle)
            thirdLayer.append(paddle)
        }
        
        createPin(named: "thirdLayerPin", imageName: paddlePinName, atLocation: CGPoint(x: 400, y: -156.5))
    }
    
    func createFourthLayer() {
        for i in 0 ... 7 {
            let paddle = PaddleNode()
            paddle.position = CGPoint(x: CGFloat(70 * i) - 244.5, y: -311.5)
            paddle.zPosition = 1
            addChild(paddle)
            fourthLayer.append(paddle)
        }
        
        createPin(named: "fourthLayerPin", imageName: paddlePinName, atLocation: CGPoint(x: 400, y: -311.5))
    }
    
    func createPin(named name: String, imageName: String, atLocation location: CGPoint, base: PinNode.Base = .both) {
        let pin = PinNode(pinImageName: imageName)
        pin.name = name
        pin.base = base
        pin.position = location
        pin.zPosition = 1
        pin.delegate = self
        addChild(pin)
    }
    
    func createCell(color: UIColor, position: CGPoint, number: Int) {
        let cellNode = MarbleCell(color: color, number: number)
        cellNode.position = position
        cellNode.zPosition = -1
        
        addChild(cellNode)
    }
    
    func createBall(of color: UIColor, at location: CGPoint) {
        let ball = MarbleNode(color: color)
        ball.position = location
        addChild(ball)
        marbles.append(ball)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -gravityFactor, dy: accelerometerData.acceleration.x * gravityFactor)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension GameScene: PinNodeDelegate {
    
    func pinMoved(_ sender: PinNode) {
        switch sender.name {
        case gatePinName:
            gate.offset = sender.offset
        case "firstLayerPin":
            firstLayer.forEach({ $0.offset = sender.offset })
        case "secondLayerPin":
            secondLayer.forEach({ $0.offset = sender.offset })
        case "thirdLayerPin":
            thirdLayer.forEach({ $0.offset = sender.offset })
        case "fourthLayerPin":
            fourthLayer.forEach({ $0.offset = sender.offset })
        default:
            return
        }
    }
    
    func movingToLeftBase(_ sender: PinNode) {
        switch sender.name {
        case "firstLayerPin":
            firstLayer.forEach({ $0.moveToLeft() })
        case "secondLayerPin":
            secondLayer.forEach({ $0.moveToLeft() })
        case "thirdLayerPin":
            thirdLayer.forEach({ $0.moveToLeft() })
        case "fourthLayerPin":
            fourthLayer.forEach({ $0.moveToLeft() })
        default:
            return
        }
    }
    
    func movingToRightBase(_ sender: PinNode) {
        switch sender.name {
        case gatePinName:
            gate.returnToBase()
        case "firstLayerPin":
            firstLayer.forEach({ $0.moveToRigth() })
        case "secondLayerPin":
            secondLayer.forEach({ $0.moveToRigth() })
        case "thirdLayerPin":
            thirdLayer.forEach({ $0.moveToRigth() })
        case "fourthLayerPin":
            fourthLayer.forEach({ $0.moveToRigth() })
        default:
            return
        }
    }
}

extension GameScene: ButtonNodeDelegate {
    func buttonTapped(_ sender: ButtonNode) {
        reset()
    }
}
