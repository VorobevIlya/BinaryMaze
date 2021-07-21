//
//  ButtonNode.swift
//  MarbleMaze
//
//  Created by Илья Воробьев on 21.07.2021.
//

import UIKit
import SpriteKit

protocol ButtonNodeDelegate: AnyObject {
    func buttonTapped(_ sender: ButtonNode)
}

class ButtonNode: SKLabelNode {
    
    weak var delegate: ButtonNodeDelegate?
    
    init(label: String) {
        super.init()
        
        isUserInteractionEnabled = true
        
        text = label
        fontName = "Chalkduster"
        fontSize = 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.buttonTapped(self)
    }
}
