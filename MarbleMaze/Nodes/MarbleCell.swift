//
//  MarbleCell.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 21.07.2021.
//
import SpriteKit
import UIKit

class MarbleCell: SKSpriteNode {
    
    init(color: UIColor, number: Int) {
        let texture = SKTexture(imageNamed: "MarbleCell")
        
        super.init(texture: texture, color: color, size: texture.size())
        
        colorBlendFactor = 1
        
        let numberNode = SKLabelNode(fontNamed: "Chalkduster")
        numberNode.fontSize = 20
        numberNode.text = String(number)
        numberNode.zPosition = 2
        
        addChild(numberNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
