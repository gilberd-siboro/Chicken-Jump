//
//  GameScene.swift
//  Chicken Jump
//
//  Created by Foundation-005 on 01/07/24.
//

import UIKit
import SpriteKit
import SwiftUI



class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var pijakan: SKSpriteNode?
    var obstacle1: SKSpriteNode?
    var obstacle2: SKSpriteNode?
    var veryFirstObstacle: SKSpriteNode?
    var hpLabel: SKLabelNode?
    var steps: [SKSpriteNode] = []
    var xPosition = [-150, 150]
    var hp = "❤️❤️❤️"
    var obstacle1Exist = false
    var obstacles: [SKSpriteNode?] = []
    var jagung1: SKSpriteNode?
    var cornIcon = "🌽"
    var playPauseButton: UIButton!
    var isPausedGame: Bool = false
    let jagungCategory: UInt32 = 0x4 << 2
    let ayamCategory: UInt32 = 0x1 << 0
    var chicken: SKSpriteNode?
    var chickenPosition = 0 // Start at step1 (index 0)
    var actionChicken: SKSpriteNode?
    var score: SKLabelNode?
    var invisibleBlock: SKSpriteNode?
    var poin = 0 {
        didSet {
            score?.text = "\(cornIcon) \(poin)"
        }
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        chicken = self.childNode(withName: "//Chicken") as? SKSpriteNode
        pijakan = childNode(withName: "//Step1") as? SKSpriteNode
        obstacle1 = childNode(withName: "//Step2") as? SKSpriteNode
        obstacle2 = childNode(withName: "//Step3") as? SKSpriteNode
        jagung1 = childNode(withName: "//jagung1") as? SKSpriteNode
        chicken?.physicsBody = SKPhysicsBody(rectangleOf: chicken!.size)
        //        chicken?.physicsBody?.friction = 0.0
        //        chicken?.physicsBody?.restitution = 1.0
        //        chicken?.physicsBody?.linearDamping = 0.0
        //        chicken?.physicsBody?.angularDamping = 0.0
        chicken?.physicsBody?.affectedByGravity = true
        chicken?.physicsBody?.categoryBitMask = 1
        chicken?.physicsBody?.collisionBitMask = 2
        chicken?.physicsBody?.contactTestBitMask = 2
        chicken?.physicsBody?.allowsRotation = false
        chicken?.physicsBody?.categoryBitMask = ayamCategory
        chicken?.physicsBody?.contactTestBitMask = jagungCategory
        
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
        
        jagung1?.name = "Jagung1"
        
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
        
        hpLabel  = SKLabelNode(text: "\(hp)")
        hpLabel?.zPosition = 15
        //        hpLabel?.frame ==> size
        hpLabel?.position = CGPoint(x: 200, y: size.height/2 - 50)
        
        addChild(hpLabel!)
        
        repeatedlySpawnObstacle()
        repeatedlySpawnJagung1()
        //        spawnChicken()
        
        setupScore()
        
    }
    
    @objc func swipeRight() {
        print("swipeRight")
        
        // jump to right
        guard let chicken = actionChicken else { return }
        chicken.physicsBody = nil
        
        
        // Create a path for the jump
        chicken.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: 300, y: 150), controlPoint: CGPoint(x: 0, y: 400))
        
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 500)
        move.timingMode = .easeInEaseOut
        
        //        let wait  = SKAction.wait(forDuration: 0.1)
        let activatePhysic = SKAction.run {
            //            guard let chicken = actionChicken else { return }
            
            chicken.physicsBody = SKPhysicsBody(rectangleOf: chicken.size)
            chicken.physicsBody?.isDynamic = true
            chicken.physicsBody?.allowsRotation = false
            chicken.physicsBody?.affectedByGravity = true
            chicken.physicsBody?.contactTestBitMask = chicken.physicsBody?.collisionBitMask ?? 0
        }
        
        chicken.run(SKAction.sequence([move, activatePhysic]))
        
        
    }
    
    @objc func swipeLeft() {
        guard let chicken = actionChicken else { return }
        chicken.physicsBody = nil
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: -300, y: 150), controlPoint: CGPoint(x: 0, y: 400))
        
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: false, speed: 800)
        move.timingMode = .easeInEaseOut
        
        
        let activatePhysic = SKAction.run {
            //            guard let chicken = actionChicken else { return }
            
            chicken.physicsBody = SKPhysicsBody(rectangleOf: chicken.size)
            chicken.physicsBody?.isDynamic = true
            chicken.physicsBody?.allowsRotation = false
            chicken.physicsBody?.affectedByGravity = true
            chicken.physicsBody?.contactTestBitMask = chicken.physicsBody?.collisionBitMask ?? 0
        }
        
        chicken.run(SKAction.sequence([move, activatePhysic]))
        
        
    }
    
    @objc func swipeUp(){
        //        if chickenPosition < steps.count - 1 {
        //            chickenPosition += 2
        //            jumpChicken(to: .up)
        //        }
        
    }
    
    enum Direction {
        case left
        case right
        case up
        
    }
    
    func setupScore() {
        let background = SKShapeNode(rectOf: CGSize(width: 150, height: 80), cornerRadius: 15)
        background.fillColor = .lightGray
        background.lineWidth = 2
        background.position = CGPoint(x: frame.midX + 220, y: frame.maxY - 130)
        background.zPosition = 90 // Di bawah label skor
        addChild(background)
        
        score = SKLabelNode(fontNamed: "Garamond")
        score?.text = "0"
        score?.fontSize = 40
        score?.fontColor = .black
        score?.position = CGPoint(x: frame.midX + 220, y: frame.maxY - 150)
        score?.zPosition = 100
        addChild(score!)
    }
    
    func repeatedlySpawnJagung1() {
        let spawnAction = SKAction.run {
            self.spawnJagung1()
        }
        let waitAction = SKAction.wait(forDuration: 4)
        let spawnAndWaitAction = SKAction.sequence([waitAction, spawnAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnJagung1() {
        if let newJagung1 = jagung1?.copy() as? SKSpriteNode {
            let randomX = xPosition[Int.random(in: 0...1)]
            newJagung1.position = CGPoint(x: randomX, y: 2000)
            newJagung1.physicsBody = SKPhysicsBody(rectangleOf: newJagung1.size)
            newJagung1.physicsBody?.isDynamic = false
            newJagung1.physicsBody?.allowsRotation = false
            newJagung1.physicsBody?.categoryBitMask = jagungCategory
            newJagung1.physicsBody?.contactTestBitMask = ayamCategory
            newJagung1.name = "Jagung1"
            addChild(newJagung1)
            moveJagung1(node: newJagung1)
            
        }
    }
    
    func moveJagung1(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -800, duration: 5)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
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
        // Implementasi untuk mengakhiri permainan (kembali ke menu utama)
        if let viewController = self.view?.window?.rootViewController as? MainMenuViewController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func repeatedlySpawnObstacle() {
        let spawnAction = SKAction.run {
            self.spawnObstacles()
        }
        let waitAction = SKAction.wait(forDuration: 2.5)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    var lastXPositionOfObstacle = 150
    var firstObstaclePosition: CGPoint?
    
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
            //            newObstacle.physicsBody = nil
            newObstacle.physicsBody = SKPhysicsBody(rectangleOf: newObstacle.size)
            newObstacle.physicsBody?.isDynamic = false
            newObstacle.physicsBody?.affectedByGravity = false
            newObstacle.physicsBody?.allowsRotation = false
            
            print(newObstacle.name)
            
            
            addChild(newObstacle)
            
            if veryFirstObstacle == nil {
                veryFirstObstacle = newObstacle.copy() as? SKSpriteNode
                
                
                spawnChicken()
            }
            
            moveObstacle1(node: newObstacle)
            
            
            // Store the position of the first spawned obstacle if not already set
            if firstObstaclePosition == nil {
                firstObstaclePosition = newObstacle.position
            }
        }
        
        if randomObstacle == obstacle1 {
            obstacle1Exist = true
        }
    }
    
    func spawnChicken() {
        
        
        if let chicken1 = chicken?.copy() as? SKSpriteNode {
            chicken1.size = CGSize(width: 150, height: 150)
            chicken1.position =   veryFirstObstacle!.position // CGPoint(x: 270, y: -370)
            //chicken1.position.y = chicken1.position.y + 200
            chicken1.zPosition = 9
            
            chicken1.physicsBody = SKPhysicsBody(rectangleOf: chicken1.size)
            chicken1.physicsBody?.isDynamic = true
            chicken1.physicsBody?.allowsRotation = false
            chicken1.physicsBody?.affectedByGravity = true
            chicken1.physicsBody?.contactTestBitMask = chicken1.physicsBody?.collisionBitMask ?? 0
            
            addChild(chicken1)
            
            actionChicken = chicken1
            
            //chicken1.run(SKAction.moveTo(y: -800, duration: 15))
        }
    }
    
    
    func moveObstacle1(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -800, duration: 15)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        
        if nodeB.name == "Chicken" && nodeA.name == "Step2" || nodeA.name == "Chicken" && nodeB.name == "Step2" {
            
            
            print("body A: \(nodeA.name)")
            print("body B: \(nodeB.name)")
            
            
            let changeTexture = SKAction.setTexture(SKTexture(imageNamed: "pijakan"))
            
            
            if nodeA.name == "Step2" {
                nodeA.run(changeTexture)
            }
            
            if nodeB.name == "Step2" {
                nodeB.run(changeTexture)
            }
            
            
            if hp.count > 0{
                hp.removeLast()
                hpLabel?.text = "\(hp)" // Update the label text explicitly
            }
            
            // Update hp label
            hpLabel?.text = "\(hp)"
            
            // Check if HP is depleted
            if hp.isEmpty {
                showGameOver()
            }
            
            
        }
    }
    
    
    //        if (bodyA.categoryBitMask == ayamCategory && bodyB.categoryBitMask == jagungCategory) ||
    //               (bodyA.categoryBitMask == jagungCategory && bodyB.categoryBitMask == ayamCategory) {
    //            if let jagung = (bodyA.categoryBitMask == jagungCategory ? bodyA.node : bodyB.node) {
    //                jagung.removeFromParent()
    //            //    updateScore()
    //            }
    //        }
    // handle collision chicken & trap
    //
    //        if nodeA.name == "Chicken" && nodeB.name == "Step2" {
    //                nodeB.removeFromParent()
    //                nodeB.name = "Step1" // Ubah nama nodeB menjadi "Step1"
    
    //                // Kurangi HPpause
    //                if hp.count > 0 {
    //                    hp.removeLast()
    //                }
    //
    //                // Update hp label
    //                hpLabel?.text = "\(hp)"
    //
    //                // Check if HP is depleted
    //                if hp.isEmpty {
    //                    showGameOver()
    //                }
    //            }
    
    
    
    func showGameOver(){
        // transition to GameOverScene
        if let gameOverScene = SKScene(fileNamed: "GameOverScene"){
            
            gameOverScene.scaleMode = .aspectFill
            gameOverScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.reveal(with: .down, duration: 1)
            
            view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    
    
    
    
    //    func updateScore() {
    //        poin += 5
    //        score?.text = "\(cornIcon) \(poin)"
    //        print("Skor bertambah Skor saat ini: \(cornIcon) \(poin)")
    //
    //    }
    
    
    
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
    
}
