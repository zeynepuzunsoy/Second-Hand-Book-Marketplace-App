//
//  CreateAddressVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 12.06.2023.
//

import UIKit

class CreateAddressVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var address: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        createAddress()
        if let AddressVC = storyboard?.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
            navigationController?.pushViewController(AddressVC, animated: true)
        }
    }
    

    func createAddress() {
        guard let url = URL(string: "http://localhost:8000/api/createAddress") else {
            print("Invalid URL")
            return
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body parameters
        let parameters: [String: Any] = [
            "name": name.text ?? "",
            "lastname": lastname.text ?? "",
            "phone_number": phoneNumber.text ?? "",
            "city": city.text ?? "",
            "district": district.text ?? "",
            "address": address.text ?? "",
            "zipcode": zipcode.text ?? "",
            "is_default": false
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
                    let response = try decoder.decode(AddressResponse.self, from: data)
                    let addresses = response.address
                    
                    // Handle the addresses data as needed
                    print("Addresses:", addresses)
                } catch {
                    print("Error parsing JSON data:", error)
                }

            }
            
            self.showAlert(title: "Adres Ekleme", message: "Adres başarılı bir şekilde kaydedildi.")
            
          
            
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
