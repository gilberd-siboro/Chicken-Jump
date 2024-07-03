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
    var hpLabel: SKLabelNode?
    var xPosition = [-150, 150]
    var hp = "❤️❤️❤️"
    var obstacle1Exist = false
    var obstacles: [SKSpriteNode?] = []
    
    var playPauseButton: UIButton!
    var isPausedGame: Bool = false

    
    override func didMove(to view: SKView) {
        pijakan = childNode(withName: "//pijakan") as? SKSpriteNode
        obstacle1 = childNode(withName: "//obstacle1") as? SKSpriteNode
        obstacle2 = childNode(withName: "//obstacle2") as? SKSpriteNode
        
        obstacles.append(pijakan)
        obstacles.append(pijakan)
        obstacles.append(pijakan)
        obstacles.append(obstacle1)
        obstacles.append(obstacle2)
        
        playPauseButton = UIButton(type: .system)
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        //Sesuaikan posisi dan ukuran tombol
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        
        repeatedlySpawnObstacle()
    }

    @objc func playPauseButtonTapped(_ sender: UIButton) {
        if isPausedGame {
            isPausedGame = false
            sender.setTitle("Pause", for: .normal)
            // Implementasi untuk melanjutkan permainan (jika perlu)
            self.isPaused = false
            // Hilangkan alert jika ada
            if let viewController = view?.window?.rootViewController {
                viewController.dismiss(animated: true, completion: nil)
            }
        } else {
            isPausedGame = true
            sender.setTitle("Play", for: .normal)
            // Implementasi untuk menjeda permainan (jika perlu)
            self.isPaused = true
            
            // Tampilkan alert
            let alertController = UIAlertController(title: "Game Paused", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (_) in self.resumeGame()
            }))
            alertController.addAction(UIAlertAction(title: "End Game", style: .destructive, handler: { (_) in self.endGame()
            }))
            if let viewController = view?.window?.rootViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Method untuk melanjutkan permainan
        func resumeGame() {
            isPausedGame = false
            playPauseButton.setTitle("Pause", for: .normal)
            self.isPaused = false
        }
        
        // Method untuk mengakhiri permainan
        func endGame() {
            // Implementasi untuk mengakhiri permainan (misalnya kembali ke menu utama)
            if let viewController = view?.window?.rootViewController as? GameViewController {
                viewController.dismiss(animated: true, completion: nil)
            }
        }

    
    func repeatedlySpawnObstacle() {
        let spawnAction = SKAction.run {
            self.spawnObstacles()
        }
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
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
    
    func moveObstacle1(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -800, duration: 15)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }

    
    func didBegin(_ contact: SKPhysicsContact){
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // handle collision chicken & trap
        if nodeA.name == "chicken2" && nodeB.name == "obstacel1"{
            nodeB.removeFromParent()
            
            if nodeA.name == "chicken3" && nodeB.name == "obstacel1"{
                nodeB.removeFromParent()
                
                if hp.count > 0 {
                    hp.removeLast()
                }
                
                // update hp label
                hpLabel?.text = "\(hp)"
                
                if hp.count == 0 {
                    showGameOver()
                }
            }
        }
        
        func showGameOver(){
            // transition to GameOverScene
            if let gameOverScene = SKScene(fileNamed: "GameOverScene"){
                
                gameOverScene.scaleMode = .aspectFill
                gameOverScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let transition = SKTransition.reveal(with: .down, duration: 1)
                
                view?.presentScene(gameOverScene, transition: transition)
            }
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

// knknjkn
