//
//  GameScene.swift
//  Chicken Jump
//
//  Created by Foundation-010 on 27/06/24.
//

import SpriteKit
import UIKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var chicken: SKSpriteNode?
    var steps: [SKSpriteNode] = []
    var bgPlay: SKSpriteNode?
    var chickenPosition = 0 // Start at step1 (index 0)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        chicken = self.childNode(withName: "//Chicken") as? SKSpriteNode
        for i in 1...5 {
            if let step = self.childNode(withName: "//Step\(i)") as? SKSpriteNode {
                steps.append(step)
            }
        }
        
        // Set up physics body for chicken
        chicken?.physicsBody = SKPhysicsBody(rectangleOf: chicken!.size)
        chicken?.physicsBody?.affectedByGravity = true
        chicken?.physicsBody?.categoryBitMask = 1
        chicken?.physicsBody?.collisionBitMask = 2
        chicken?.physicsBody?.contactTestBitMask = 2
        chicken?.physicsBody?.allowsRotation = false
        
        // Set up physics bodies for steps
        for step in steps {
            step.physicsBody = SKPhysicsBody(rectangleOf: step.size)
            step.physicsBody?.isDynamic = false
            step.physicsBody?.categoryBitMask = 2
            step.physicsBody?.collisionBitMask = 1
            step.physicsBody?.contactTestBitMask = 1
        }
        
        // Add swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipeRight() {
        if chickenPosition < steps.count - 1 {
            chickenPosition += 1
            jumpChicken(to: .right)
        }
    }
    
    @objc func swipeLeft() {
        if chickenPosition < steps.count - 1 {
            chickenPosition += 1
            jumpChicken(to: .left)
        }
    }
    
    @objc func swipeUp(){
        if chickenPosition < steps.count - 1 {
            chickenPosition += 2
            jumpChicken(to: .up)
        }
        
    }
    
    enum Direction {
        case left
        case right
        case up
        
    }
    
    func jumpChicken(to direction: Direction) {
        guard let chicken = chicken else { return }
        
        let targetX: CGFloat
        let targetY: CGFloat = 400 // Adjust this value to control the peak height of the jump
        
        switch direction {
        case .left:
            targetX = chicken.position.x
        case .right:
            targetX = chicken.position.x
        case .up :
            targetX = chicken.position.y
        }
        
        let midPointX = (chicken.position.x + targetX) / 2
        let midPointY = chicken.position.y + targetY
        
        
        
        let targetPoint = CGPoint(x: steps[chickenPosition ].position.x, y: steps[chickenPosition ].position.y)
        
        
        // Create a path for the jump
        let path = UIBezierPath()
        path.move(to: chicken.position)
        path.addQuadCurve(to: targetPoint, controlPoint: CGPoint(x: midPointX, y: midPointY))
        
        
        let followPath = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, duration: 0.4)
        followPath.timingMode = .easeInEaseOut
        
//        return
        chicken.run(followPath) {
            self.chicken?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.chicken?.physicsBody?.affectedByGravity = false
            
            // Ensure chicken is on the target step
//            if let targetStep = self.steps[safe: self.chickenPosition] {
////                self.chicken?.position = CGPoint(x: targetStep.position.x, y: targetStep.position.y + (self.chicken?.size.height ?? 0) / 2 + (targetStep.size.height / 2))
//            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (1 | 2) {
            // Chicken has landed on a step
            chicken?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
