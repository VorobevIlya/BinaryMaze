//
//  MarbleNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 21.07.2021.
//

import UIKit
import SpriteKit

class MarbleNode: SKSpriteNode {
    
    let radius: CGFloat = 13
    
    init(color: UIColor) {
        let texture = SKTexture(imageNamed: "Marble")
        
        super.init(texture: texture, color: color, size: texture.size())
        
        colorBlendFactor = 1
        
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
