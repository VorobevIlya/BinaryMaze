//
//  GateNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 18.07.2021.
//

import UIKit
import SpriteKit

class GateNode: SKNode {
    
    let rightLimit = CGPoint(x: 18, y: 0)
    let leftLimit = CGPoint(x: -18, y: 0)
    let bodyGap: CGFloat = 65
    
    var range: CGFloat {
        return rightLimit.x - leftLimit.x
    }
    
    var offset: CGFloat {
        get {
            return (gateBody.position.x - leftLimit.x) / range
        }
        set(offset) {
            gateBody.position.x = leftLimit.x + offset * range
        }
    }
    
    var gateBody = SKNode()
    
    override init() {
        super.init()
        
        let backGround = SKSpriteNode(imageNamed: "GateBackground")
        backGround.zPosition = -1
        addChild(backGround)
        
        let rightBody = SKSpriteNode(imageNamed: "GateBody")
        rightBody.position = CGPoint(x: bodyGap / 2, y: 0)
        rightBody.zPosition = 1
        rightBody.physicsBody = SKPhysicsBody(rectangleOf: rightBody.size)
        rightBody.physicsBody?.categoryBitMask = BitMaskCategories.gate.rawValue
        rightBody.physicsBody?.collisionBitMask = BitMaskCategories.ball.rawValue
        rightBody.physicsBody?.isDynamic = false
        
        let leftBody = SKSpriteNode(imageNamed: "GateBody")
        leftBody.position = CGPoint(x: -bodyGap / 2, y: 0)
        leftBody.zPosition = 1
        leftBody.physicsBody = SKPhysicsBody(rectangleOf: leftBody.size)
        leftBody.physicsBody?.categoryBitMask = BitMaskCategories.gate.rawValue
        leftBody.physicsBody?.collisionBitMask = BitMaskCategories.ball.rawValue
        leftBody.physicsBody?.isDynamic = false
        
        gateBody.addChild(leftBody)
        gateBody.addChild(rightBody)
        
        gateBody.position = leftLimit
        
        addChild(gateBody)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func returnToBase() {
        gateBody.run(SKAction.move(to: rightLimit, duration: 0.1))
    }
}
