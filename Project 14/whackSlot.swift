//
//  whackSlot.swift
//  Project 14
//
//  Created by macbook on 1/15/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import SpriteKit

class whackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false

    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        addChild(cropNode)
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        cropNode.addChild(charNode)
    }
    
    func show(hidetime: Double) {
        if isVisible {return}
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "good"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "evil"
        }
        
        let show = SKAction.moveBy(x: 0, y: 80, duration: 0.05)
        
        charNode.run(show)
        
        hide(hidetime: hidetime)
    }
    
    func hide(hidetime: Double) {
        if !isVisible {return}
        
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.05)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hidetime * 3.5)) {
            [weak self] in
            self?.charNode.run(hide)
            self?.isVisible = false
        }
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let move = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let hide = SKAction.run {
            [weak self] in
            self!.isVisible = false
        }
        let sequence = SKAction.sequence([delay, move, hide])
        charNode.run(sequence)
    }
    
}
