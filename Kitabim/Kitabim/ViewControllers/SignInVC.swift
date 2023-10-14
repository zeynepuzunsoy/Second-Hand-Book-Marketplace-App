//
//  SignInVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 18.03.2023.
//

import UIKit
import Alamofire


class SignInVC: UIViewController {

    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
       emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        
        emailTextField.layer.applySketchShadow(color: UIColor.black, alpha: 0.1, x: 2, y:2 , blur: 10, spread: 0)
        passwordTextField.layer.applySketchShadow(color: UIColor.black, alpha: 0.1, x: 2, y:2 , blur: 10, spread: 0)
        
        
        
    }
    

    @IBAction func signInClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            if let email = emailTextField.text , email.isEmpty {
                showAlert(message: "E-posta alanı boş olamaz.")
            }
            else if let password = passwordTextField.text , password.isEmpty {
                showAlert(message: "Şifre alanı boş olamaz.")
            }
            return
        }
        
        
        let users : [String: Any] = [
            "email":email,
            "password":password
        ]
        
        AF.request("http://localhost:8000/api/sign-in", method: .post, parameters: users,encoding: JSONEncoding.default).validate()
            .responseDecodable(of: SignInResponse.self) {
                response in
                switch response.result {
                case .success(let SignInResponse):
                    let user = SignInResponse.user
                    let token = SignInResponse.token
                    
                   
                    
                    print("Kullanıcı giriş yaptı: \(user)")
                    print("Token: \(token)")
                    
                    UserDefaults.standard.set(token, forKey: "isLoggedIn")
                   
                    let targetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarID")
                    targetViewController.modalPresentationStyle = .overFullScreen
                    self.present(targetViewController, animated: true, completion: nil)

                    
                case .failure(let error):
                print("Hata: \(error)")
                    self.showAlert(message: "Kullanıcı bulunamadı. Lütfen girdiğiniz bilgileri kontrol edin.")
                    
                }
            }
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func newPasswordClicked(_ sender: Any) {
        
    }
    
  
    
   

}
