//
//  createCreditCardVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 13.06.2023.
//

import UIKit

class CreateCreditCardVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cardNo: UITextField!
    @IBOutlet weak var expireMonth: UITextField!
    @IBOutlet weak var expireYear: UITextField!
    @IBOutlet weak var cvc: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        createCard()
    }
    
    func createCard() {
        guard let url = URL(string: "http://localhost:8000/api/createCreditCard") else {
            print("Invalid URL")
            return
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body parameters
        
        let parameters: [String: Any] = [
                "name": name.text ?? "",
                "card_no": cardNo.text ?? "",
                "expire_month": expireMonth.text ?? "",
                "expire_year": expireYear.text ?? "",
                "cvc": cvc.text ?? ""
            ]
        
        
        // Set the request body data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error creating JSON data:", error)
            return
        }
        
        // Set the request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication token to the request header
        if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Create a URLSession task to send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error:", error)
                return
            }
            
            if let data = data {
                // Parse the response JSON data
                // Parse the response JSON data
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CreditCardResponse.self, from: data)
                    let creditcard = response.creditCard
                    
                    // Handle the addresses data as needed
                    print("CreditCard:", creditcard)
                } catch {
                    print("Error parsing JSON data:", error)
                }
                
            }
            
            self.showAlert(title: "Kart Ekleme", message: "Kart başarılı bir şekilde kaydedildi.")
            
            
            
        }
        
        // Start the URLSession task
        task.resume()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
