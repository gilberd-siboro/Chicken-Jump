//
//  TutorialViewController.swift
//  Chicken Jump
//
//  Created by Foundation-010 on 27/06/24.
//

import UIKit

class TutorialViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func goBack(_ seqnder: Any) {
        if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    dismiss(animated: true, completion: nil)
                }
    }
    
//    @IBAction func goHomeButton(_ sender: Any) {
//    }
//        @IBAction func goHomeButton(_ sender: Any) {
//        dismiss(animated: true)
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
