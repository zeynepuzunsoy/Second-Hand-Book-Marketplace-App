//
//  SettingsVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 21.03.2023.
//

import UIKit
import Alamofire


class SettingsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("token alınamadı")
              return
          }
          
          let headers: HTTPHeaders = [
              "Authorization": "Bearer \(token)"
          ]
          
          AF.request("http://localhost:8000/api/logout", method: .post, headers: headers).validate().responseDecodable(of: LogoutResponse.self) { response in
              switch response.result {
              case .success:
                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  if let viewController = storyboard.instantiateInitialViewController() {
                      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                         let sceneDelegate = windowScene.delegate as? SceneDelegate {
                          sceneDelegate.window?.rootViewController = viewController
                          sceneDelegate.window?.makeKeyAndVisible()
                          
//                          UserDefaults.standard.removeObject(forKey: "accessToken")

                          UserDefaults.standard.set(false, forKey: "isLoggedIn")
       
                          

                          print("Kullanıcı çıkış yaptı")
                      }
                  }
                  
              case .failure(let error):
                  print("Logout request failed with error: \(error)")
              }
          }
        
        }
    }
