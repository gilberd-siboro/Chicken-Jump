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
    
    override func didMove(to view: SKView) {
        pijakan = childNode(withName: "//pijakan") as? SKSpriteNode
        obstacle1 = childNode(withName: "//obstacle1") as? SKSpriteNode
        obstacle2 = childNode(withName: "//obstacle2") as? SKSpriteNode
        
        repeatedlySpawnPijakan()
        repeatedlySpawnObstacle1()
        repeatedlySpawnObstacle2()
    }
    
    func repeatedlySpawnPijakan() {
        let spawnAction = SKAction.run {
            self.spawnPijakan()
        }
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnPijakan() {
        if let newPijakan = pijakan?.copy() as? SKSpriteNode {
            newPijakan.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
            newPijakan.physicsBody = SKPhysicsBody(rectangleOf: newPijakan.size)
            newPijakan.physicsBody?.isDynamic = false
            
            addChild(newPijakan)
            
            movePijakan(node: newPijakan)
        }
    }
    
    func movePijakan(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 5)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func repeatedlySpawnObstacle1() {
        let spawnAction = SKAction.run {
            self.spawnObstacle1()
        }
        let waitAction = SKAction.wait(forDuration: 3)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnObstacle1() {
        if let newObstacle1 = obstacle1?.copy() as? SKSpriteNode {
            newObstacle1.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
            newObstacle1.physicsBody = SKPhysicsBody(rectangleOf: newObstacle1.size)
            newObstacle1.physicsBody?.isDynamic = false
            
            addChild(newObstacle1)
            
            moveObstacle1(node: newObstacle1)
        }
    }
    
    func moveObstacle1(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 6)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func repeatedlySpawnObstacle2() {
        let spawnAction = SKAction.run {
            self.spawnObstacle2()
        }
        let waitAction = SKAction.wait(forDuration: 4)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnObstacle2() {
        if let newObstacle2 = obstacle2?.copy() as? SKSpriteNode {
            newObstacle2.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
            newObstacle2.physicsBody = SKPhysicsBody(rectangleOf: newObstacle2.size)
            newObstacle2.physicsBody?.isDynamic = false
            
            addChild(newObstacle2)
            
            moveObstacle2(node: newObstacle2)
        }
    }
    
    func moveObstacle2(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 5)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
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

