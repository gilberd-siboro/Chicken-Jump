
//  MainMenuViewController.swift
//  Chicken Jump
//
//  Created by Foundation-010 on 27/06/24.
//

import UIKit
import AVFoundation


class MainMenuViewController: UIViewController {

    @IBOutlet weak var muteButton: UIButton!
    var isMute = false
    
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
    //    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
