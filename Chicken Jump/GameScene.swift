import UIKit
import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var pijakan: SKSpriteNode?
    var jagung1: SKSpriteNode?
    var score: SKLabelNode?
    var ayam: SKSpriteNode?
    
    var xPosition = [-150, 150]
    
    var cornIcon = "🌽"
    var ayamPosition = 1
    
    var poin = 0 {
        didSet {
            score?.text = "\(cornIcon) \(poin)"
        }
    }
    
    let ayamCategory: UInt32 = 0x1 << 0
    let pijakanCategory: UInt32 = 0x1 << 1
    let jagungCategory: UInt32 = 0x1 << 2

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        pijakan = childNode(withName: "//pijakan") as? SKSpriteNode
        jagung1 = childNode(withName: "//jagung1") as? SKSpriteNode
        ayam = childNode(withName: "//ayam") as? SKSpriteNode
        
        ayam?.name = "Ayam"
        jagung1?.name = "Jagung1"
        
        ayam?.physicsBody = SKPhysicsBody(rectangleOf: ayam?.size ?? .zero)
        ayam?.physicsBody?.affectedByGravity = false
        ayam?.physicsBody?.allowsRotation = false
        ayam?.physicsBody?.isDynamic = true
        ayam?.physicsBody?.categoryBitMask = ayamCategory
        ayam?.physicsBody?.collisionBitMask = pijakanCategory
        ayam?.physicsBody?.contactTestBitMask = jagungCategory
        
        repeatedlySpawnJagung1()
        
        setupScore()
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
        let waitAction = SKAction.wait(forDuration: 1)
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnJagung1() {
        if let newJagung1 = jagung1?.copy() as? SKSpriteNode {
            let randomX = xPosition[Int.random(in: 0...1)]
            newJagung1.position = CGPoint(x: randomX, y: 700)
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
        let moveDownAction = SKAction.moveTo(y: -700, duration: 3)
        let removeNodeAction = SKAction.removeFromParent()
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func updateAyamPosition() {
        let newX = (ayamPosition == 1) ? -150 : 150
        ayam?.run(SKAction.moveTo(x: CGFloat(newX), duration: 0.1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    @objc func swipeRight() {
        ayamPosition = 2
        updateAyamPosition()
        print("Ke kanan...")
    }
    
    @objc func swipeLeft() {
        ayamPosition = 1
        updateAyamPosition()
        print("Ke kiri...")
    }
    
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == ayamCategory && bodyB.categoryBitMask == jagungCategory) ||
               (bodyA.categoryBitMask == jagungCategory && bodyB.categoryBitMask == ayamCategory) {
            if let jagung = (bodyA.categoryBitMask == jagungCategory ? bodyA.node : bodyB.node) {
                jagung.removeFromParent()
                updateScore()
            
            }
        } else if (bodyA.categoryBitMask == ayamCategory && bodyB.categoryBitMask == pijakanCategory) ||
           (bodyA.categoryBitMask == pijakanCategory && bodyB.categoryBitMask == ayamCategory) {
            if let ayam = (bodyA.categoryBitMask == ayamCategory ? bodyA.node : bodyB.node),
               let pijakan = (bodyA.categoryBitMask == pijakanCategory ? bodyA.node : bodyB.node) {
                ayam.physicsBody?.velocity = .zero
                ayam.position.y = pijakan.position.y + pijakan.frame.size.height/2 + ayam.frame.size.height/2
            }
        }
    }
    
    func updateScore() {
        poin += 5
        score?.text = "\(cornIcon) \(poin)"
        print("Skor bertambah Skor saat ini: \(cornIcon) \(poin)")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let ayam = self.ayam {
            if ayam.position.y < -self.frame.height / 2 {
                ayam.position.y = self.frame.height / 2
            }
            let minY = -self.frame.height / 2 + ayam.frame.height / 2
            if ayam.position.y < minY {
                ayam.position.y = minY
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

struct ContentView: View {
    var body: some View {
        SceneKitView()
            .edgesIgnoringSafeArea(.all)
    }
}
