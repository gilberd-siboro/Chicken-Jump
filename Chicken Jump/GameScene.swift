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
    // Deklarasi tombol play/pause
    var playPauseButton: UIButton!
    var isPausedGame: Bool = false
    
    override func didMove(to view: SKView) {
        pijakan = childNode(withName: "//pijakan") as? SKSpriteNode
        obstacle1 = childNode(withName: "//obstacle1") as? SKSpriteNode
        obstacle2 = childNode(withName: "//obstacle2") as? SKSpriteNode
        
     //playpause
        playPauseButton = UIButton(type: .system)
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        //Sesuaikan posisi dan ukuran tombol
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        repeatedlySpawnPijakan()
        repeatedlySpawnObstacle1()
        repeatedlySpawnObstacle2()
    }
    
    // Method untuk handling tombol play/pause
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

// knknjkn
