
//  MainMenuViewController.swift
//  Chicken Jump
//
//  Created by Foundation-010 on 27/06/24.
//

import UIKit
import AVFoundation
import SpriteKit


class MainMenuViewController: UIViewController {

    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    var gameScene: GameScene!
    
    
    //cek music playernya tadi dibuat dimana
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }

    
    @IBAction func changeMuteStatus(_ sender: Any) {
        if !isMute{
            muteButton.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
            isMute = true//mutebacksound
            appDelegate.music?.stop()
        }else {
            muteButton.setImage(UIImage (systemName : "speaker.circle.fill"), for: .normal)
            isMute = false
            //music lanjut
            appDelegate.music?.play()
        }
    }
    
    @IBAction func startGameButtonTapped(_ sender: UIButton) {
        // Initialize and present GameScene
        let gameScene = GameScene(size: skView.bounds.size)
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
    }


        func gameOver() {
            // Dismiss the game view controller and go back to the main menu
            dismiss(animated: true, completion: nil)
        }

    func didEndGame() {
            // Kembali ke menu utama
            gameOver()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


