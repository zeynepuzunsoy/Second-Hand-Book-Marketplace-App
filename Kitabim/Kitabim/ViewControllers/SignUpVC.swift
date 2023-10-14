//
//  SignUpVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 18.03.2023.
//

import UIKit
import Alamofire


class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        usernameTextField.layer.cornerRadius = 15
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        confirmPasswordText.layer.cornerRadius = 15
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let confirmPassword = confirmPasswordText.text , !confirmPassword.isEmpty
        else{
            if let usernameText = usernameTextField.text, usernameText.isEmpty {
                showAlert(message: "Kullanıcı adı alanı boş olamaz.")
            }
            else if let emailText = emailTextField.text , emailText.isEmpty {
                showAlert(message: "E-posta alanı boş olamaz")
            } else if let emailText = emailTextField.text, !isValidEmail(emailText) {
                   showAlert(message: "Geçerli bir e-posta adresi girin.")
            }else if let passwordText = passwordTextField.text, passwordText.isEmpty {
                showAlert(message: "Şifre alanı boş olamaz.")
            }
            else if let confirmPasswordText = confirmPasswordText.text, confirmPasswordText.isEmpty {
                showAlert(message:"Şifre tekrar boş olamaz.")
            }
            return
        }
        if password != confirmPassword {
                showAlert(message: "Şifreler eşleşmiyor.")
                return
            }
//        if emailExists(email) {
//               showAlert(message: "Bu e-posta adresi zaten kullanılıyor.")
//               return
//           }
        
        let users : [String: Any] = [
            "name":username,
            "email":email,
            "password":password,
            "password_confirmation":confirmPassword
        ]
        
        AF.request("http://localhost:8000/api/sign-up", method: .post, parameters: users, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SignUpResponse.self) { response in
                guard response.error == nil else {
                    print("Hata: \(response.error!)")
                    return
                }
                
                if let signUpResponse = response.value {
                    let user = signUpResponse.user
                    let token = signUpResponse.token
                    print("Kullanıcı kaydedildi: \(user)")
                    print("Token: \(token)")
                    
                    let targetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVCID") as! SignInVC
                    self.navigationController?.pushViewController(targetViewController, animated: true)
                    
                } else {
                    print("Geçersiz yanıt formatı.")
                }
            }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
//
//    func emailExists(_ email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        let parameters: [String: Any] = [
//            "email": email
//        ]
//
//        AF.request("", method: .post, parameters: parameters)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    // API isteği başarılı oldu, e-posta adresi mevcut
//                    completion(.success(true))
//
//                case .failure(let error):
//                    // API isteği başarısız oldu, hata oluştu veya e-posta adresi mevcut değil
//                    completion(.failure(error))
//                }
//            }
//    }
   
   
    
   
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
    
    

    
    
    
  
    
 
    
   

