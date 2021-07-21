//
//  BallNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 18.07.2021.
//

import UIKit
import SpriteKit

class BallNode: SKShapeNode {
    
    let radius: CGFloat = 13
    
    init(color: UIColor) {
        super.init()
        
        let myPath = CGMutablePath()
        myPath.addArc(center: .zero, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path = myPath
        strokeColor = .black
        fillColor = color
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = BitMaskCategories.ball.rawValue
        physicsBody?.collisionBitMask = BitMaskCategories.wall.rawValue | BitMaskCategories.gate.rawValue | BitMaskCategories.paddle.rawValue | BitMaskCategories.ball.rawValue
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = 0.01
        physicsBody?.friction = 0.01
        physicsBody?.restitution = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
