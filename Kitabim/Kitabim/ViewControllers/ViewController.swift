//
//  ViewController.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 18.03.2023.
//

import UIKit



class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let background = UIImageView(frame: UIScreen.main.bounds)
        background.image = UIImage(named: "background")
        background.contentMode = .scaleToFill
        view.insertSubview(background, at: 0)
        
        
        
        
    }

    
    
    @IBAction func signUpClicked(_ sender: Any) {
//        performSegue(withIdentifier: "toSignUp", sender: nil)
        
        let targetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVCID") as! SignUpVC
        self.navigationController?.pushViewController(targetViewController, animated: true)
        
        
        //        let navigationController = UINavigationController(rootViewController: targetViewController)
        //        navigationController.modalPresentationStyle = .
        //        self.present(navigationController, animated: true, completion: nil)
        
      
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        let targetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVCID") as! SignInVC
        self.navigationController?.pushViewController(targetViewController, animated: true)
        
    }
    
    
    
    
}

