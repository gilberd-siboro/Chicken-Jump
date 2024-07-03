//
//  GameScene.swift
//  Chicken Jump
//
//  Created by Foundation-005 on 01/07/24.
//

import UIKit
import SpriteKit
import SwiftUI

//import SpriteKit

class GameScene: SKScene {
    
    var pijakan: SKSpriteNode?
    var obstacle1: SKSpriteNode?
    var obstacle2: SKSpriteNode?
    var xPosition = [-150, 150]
    var obstacle1Exist = false
    
    var obstacles: [SKSpriteNode?] = []
    
    override func didMove(to view: SKView) {
        pijakan = childNode(withName: "//pijakan") as? SKSpriteNode
        
        obstacle1 = childNode(withName: "//obstacle1") as? SKSpriteNode
        obstacle2 = childNode(withName: "//obstacle2") as? SKSpriteNode
        
        obstacles.append(pijakan)
        obstacles.append(pijakan)
        obstacles.append(pijakan)
        obstacles.append(obstacle1)
        obstacles.append(obstacle2)
        
        
        /*repeatedlySpawnPijakan*/()
        repeatedlySpawnObstacle1()
//        repeatedlySpawnObstacle2()
    }
    
    func repeatedlySpawnPijakan() {
        let spawnAction = SKAction.run {
            self.spawnPijakan()
        }
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func movePijakan(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -900, duration: 15)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func spawnPijakan() {
        if let newPijakan = pijakan?.copy() as? SKSpriteNode {
            newPijakan.position = CGPoint(x: xPosition[0], y: 1000)
            newPijakan.physicsBody = SKPhysicsBody(rectangleOf: newPijakan.size)
            newPijakan.physicsBody?.isDynamic = false
            
            addChild(newPijakan)
            
            movePijakan(node: newPijakan)
        }
    }
    

    
    func repeatedlySpawnObstacle1() {
        let spawnAction = SKAction.run {
            self.spawnObstacles()
//            self.spawnObstacle1()
        }
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func moveObstacle1(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -800, duration: 15)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    var lastXPositionOfObstacle = 150
    
    func spawnObstacles() {
        var randomObstacle = obstacles.randomElement() ?? obstacle1
        
        while (obstacle1Exist == true) {
            randomObstacle = obstacles.randomElement() ?? obstacle1
            
            if randomObstacle != obstacle1 {
                obstacle1Exist = false
            }
        }
        
        if let newObstacle = randomObstacle?.copy() as? SKSpriteNode {
            
            if lastXPositionOfObstacle == 150 {
                lastXPositionOfObstacle = -150
            } else {
                lastXPositionOfObstacle = 150
            }
            newObstacle.position = CGPoint(x: lastXPositionOfObstacle, y: 1000)
            newObstacle.physicsBody = SKPhysicsBody(rectangleOf: newObstacle.size)
            newObstacle.physicsBody?.isDynamic = false
            
            addChild(newObstacle)
            
            moveObstacle1(node: newObstacle)
        }
        
    
        if randomObstacle == obstacle1 {
            obstacle1Exist = true
        }
        
    }
    
    func spawnObstacle1() {
        if let newObstacle1 = obstacle1?.copy() as? SKSpriteNode {
            
            newObstacle1.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 1000)
            newObstacle1.physicsBody = SKPhysicsBody(rectangleOf: newObstacle1.size)
            newObstacle1.physicsBody?.isDynamic = false
            
            addChild(newObstacle1)
            
            moveObstacle1(node: newObstacle1)
        }
    }
    

    func repeatedlySpawnObstacle2() {
        let spawnAction = SKAction.run {
            self.spawnObstacle2()
        }
        let waitAction = SKAction.wait(forDuration: 7)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func moveObstacle2(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 15)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func spawnObstacle2() {
        if let newObstacle2 = obstacle2?.copy() as? SKSpriteNode {
            newObstacle2.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 1000)
            newObstacle2.physicsBody = SKPhysicsBody(rectangleOf: newObstacle2.size)
            newObstacle2.physicsBody?.isDynamic = false
            
            addChild(newObstacle2)
            
            moveObstacle2(node: newObstacle2)
        }
    }
    
  
}


struct SceneKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        let scene = GameScene(size: uiView.bounds.size)
        scene.scaleMode = .aspectFill
        uiView.presentScene(scene)
    }
}

