import UIKit
import SpriteKit

class GameOverScene: SKScene {
    var backHomeLabel: SKLabelNode?
    var playAgainLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        backHomeLabel = self.childNode(withName: "//backHomeLabel") as? SKLabelNode
        
        if let backHomeLabel = backHomeLabel {
            backHomeLabel.fontName = "Marker Felt Thin"
            backHomeLabel.fontSize = 50
            backHomeLabel.fontColor = SKColor(red: 70.0/255.0, green: 99.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        }

        playAgainLabel = self.childNode(withName: "//playAgainLabel") as? SKLabelNode
        
        if let playAgainLabel = playAgainLabel {
            playAgainLabel.fontName = "Marker Felt Thin"
            playAgainLabel.fontSize = 50
            playAgainLabel.fontColor = SKColor(red: 70.0/255.0, green: 99.0/255.0, blue: 136.0/255.0, alpha: 1.0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let playAgainLabel = playAgainLabel, self.atPoint(location) == playAgainLabel {
            playAgain()
        } else if let backHomeLabel = backHomeLabel, self.atPoint(location) == backHomeLabel {
            print("Back Home Label Touched") // Debug log
            backToMainMenu()
        }
    }
    
    func playAgain() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.flipHorizontal(withDuration: 1)
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func backToMainMenu() {
        print("Posting Notification to go back to Main Menu") // Debug log
        NotificationCenter.default.post(name: Notification.Name("BackToMainMenu"), object: nil)
    }
    
}
