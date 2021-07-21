//
//  PinNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 18.07.2021.
//

import UIKit
import SpriteKit

protocol PinNodeDelegate: AnyObject {
    func pinMoved(_ sender: PinNode)
    func movingToLeftBase(_ sender: PinNode)
    func movingToRightBase(_ sender: PinNode)
}

class PinNode: SKNode {
    
    enum Base {
        case left
        case right
        case both
    }
    
    let pinNodeWidth: CGFloat = 80
    let pinNodeHeight: CGFloat = 45
    let pinNodeBorderWidth: CGFloat = 5
    let pinRightLimit: CGPoint = CGPoint(x: 18, y: 0)
    let pinLeftLimit: CGPoint = CGPoint(x: -18, y: 0)
    
    var base = Base.both
    
    var touchLocation: CGPoint?
    
    var range: CGFloat {
        return pinRightLimit.x - pinLeftLimit.x
    }
    
    var pin: SKSpriteNode!
    
    var offset: CGFloat {
        return (pin.position.x - pinLeftLimit.x) / range
    }
    
    weak var delegate: PinNodeDelegate?
    
    init(pinImageName: String) {
        super.init()
        
        name = pinImageName
        isUserInteractionEnabled = true
        
        let border = SKShapeNode(rectOf: CGSize(width: pinNodeWidth, height: pinNodeHeight), cornerRadius: pinNodeHeight / 2)
        border.strokeColor = .systemGray2
        border.lineWidth = pinNodeBorderWidth
        
        addChild(border)
        
        let cropNode = SKCropNode()
        cropNode.zPosition = 1
        
        let maskNode = SKShapeNode(rectOf: CGSize(width: pinNodeWidth - pinNodeBorderWidth, height: pinNodeHeight - pinNodeBorderWidth), cornerRadius: (pinNodeHeight - pinNodeBorderWidth) / 2)
        maskNode.fillColor = maskNode.strokeColor
        
        cropNode.maskNode = maskNode
        
        pin = SKSpriteNode(imageNamed: pinImageName)
        pin.position = pinLeftLimit
        
        cropNode.addChild(pin)
        
        addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        guard let previousTouchLocation = touchLocation else { return }
        let newTouchLocation = touch.location(in: self)
        
        let dx = newTouchLocation.x - previousTouchLocation.x
        touchLocation = newTouchLocation
        
        if pin.position.x + dx < pinLeftLimit.x {
            pin.position = pinLeftLimit
        } else if pin.position.x + dx > pinRightLimit.x {
            pin.position = pinRightLimit
        } else {
            pin.position.x += dx
        }
        
        delegate?.pinMoved(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchLocation == nil { return }
        else {
            touchLocation = nil
            let destination: CGPoint
            switch base {
            case .left: destination = pinLeftLimit
            case .right: destination = pinRightLimit
            case .both: destination = pin.position.x - pinLeftLimit.x < range / 2 ? pinLeftLimit : pinRightLimit
            }
            pin.run(SKAction.move(to: destination, duration: 0.1))
            if destination == pinLeftLimit { delegate?.movingToLeftBase(self) }
            else { delegate?.movingToRightBase(self) }
        }
    }
}
