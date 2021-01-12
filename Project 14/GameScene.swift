//
//  GameScene.swift
//  Project 14
//
//  Created by macbook on 1/15/20.
//  Copyright © 2020 example. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var slots = [whackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var popupTime = 0.85
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "chalkDuster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.showPenguin()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchNodes = nodes(at: location)
        
        for node in touchNodes {
            guard let slot = node.parent?.parent as? whackSlot else {continue}
            if !slot.isVisible {continue}
            if slot.isHit {continue}
            slot.hit()
            
            if node.name == "good" {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "evil" {
                score += 1
                
                slot.charNode.xScale = 0.85
                slot.charNode.yScale = 0.85
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = whackSlot()
        slot.configure(at: position)
        
        slots.append(slot)
        addChild(slot)
    }
    
    func showPenguin() {
        popupTime *= 0.991
        slots.shuffle()
        
        if popupTime < 0.1 {
            popupTime = 0.1
        }
        
        slots[0].show(hidetime: popupTime)
        
        if Int.random(in: 1...12) > 4 {slots[1].show(hidetime: popupTime)}
        if Int.random(in: 1...12) > 8 {slots[2].show(hidetime: popupTime)}
        if Int.random(in: 1...12) > 10 {slots[3].show(hidetime: popupTime)}
        if Int.random(in: 1...12) > 11 {slots[4].show(hidetime: popupTime)}
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self!.showPenguin()
        }
    }
}
