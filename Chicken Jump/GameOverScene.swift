//
//  GameOverScene.swift
//  Chicken Jump
//
//  Created by Foundation-011 on 01/07/24.
//

import UIKit
import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var gameOverLabel: SKLabelNode?
    var restartLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
        gameOverLabel = SKLabelNode(text: "Game Over :(")
        gameOverLabel?.fontName = "Arial Rounded MT- Bold"
        gameOverLabel?.fontSize = 50
        gameOverLabel?.color = .black
        gameOverLabel?.position = .zero
        
        addChild(gameOverLabel!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return}
        let location = touch.location(in: self)
        
        if self.atPoint(location) == restartLabel{
            restartGame()
        }
    }
    
    func restartGame(){
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            let transition = SKTransition.flipHorizontal(withDuration: 1)
            view?.presentScene(scene, transition: transition)

        }
    }
}
