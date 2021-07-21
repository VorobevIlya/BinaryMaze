//
//  PaddleNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 19.07.2021.
//

import UIKit
import SpriteKit

class PaddleNode: SKNode {
    
    let leftLimitAngle: CGFloat = .pi / 4
    let rightLimitAngle: CGFloat = -.pi / 4
    
    var range: CGFloat {
        return rightLimitAngle - leftLimitAngle
    }
    
    var offset: CGFloat {
        get {
            return (paddle.zRotation - rightLimitAngle) / range
        }
        set(offset) {
            paddle.zRotation = leftLimitAngle + offset * range
        }
    }
    
    let paddle: SKSpriteNode!
    
    override init() {
        paddle = SKSpriteNode(imageNamed: "Paddle")
        super.init()
        
        paddle.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size, center: CGPoint(x: 0, y: 10))
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = BitMaskCategories.paddle.rawValue
        paddle.physicsBody?.collisionBitMask = BitMaskCategories.ball.rawValue
        
        paddle.zRotation = leftLimitAngle
        
        addChild(paddle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToLeft() {
        paddle.run(SKAction.rotate(toAngle: leftLimitAngle, duration: 0.1))
    }
    
    func moveToRigth() {
        paddle.run(SKAction.rotate(toAngle: rightLimitAngle, duration: 0.1))
    }
}
