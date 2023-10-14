//
//  UploadAddressVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 12.06.2023.
//

import UIKit

class UploadAddressVC: UIViewController {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var discription: UITextField!
    
    var selectedAddress : Address?
    var addressId : Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let address = selectedAddress {
                    city.text = address.city
                    district.text = address.district
                    zipcode.text = address.zipcode
                    discription.text = address.address
                    name.text = address.name
                    lastname.text = address.lastname
                    phoneNumber.text = address.phoneNumber
                }

                }
        
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // Get the updated address details from text fields
                guard let addressId = selectedAddress?.addressId,
                      let city = city.text,
                      let district = district.text,
                      let zipcode = zipcode.text,
                      let address = discription.text,
                      let name = name.text,
                      let lastname = lastname.text,
                      let phoneNumber = phoneNumber.text else {
                    return
                }
                
                // Create the updated address object
                let updatedAddress = Address(addressId: addressId, userId: nil, city: city, district: district, zipcode: zipcode, address: address, isDefault: nil, deletedAt: nil, createdAt: nil, updatedAt: nil, name: name, lastname: lastname, phoneNumber: phoneNumber)
                
                // Call the API to update the address
        updateAddress(address: updatedAddress)
        
    }


    func updateAddress2(address: Address) {
        func updateAddress(_ address: Address) {
            guard let url = URL(string: "http://localhost:8000/api/uploadAddresss") else {
                print("Invalid URL")
                return
            }
            
            // Create the request object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set the request headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add authentication token to the request header
            if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            do {
                // Encode the updated address object as JSON data
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(address)
                
                // Attach the JSON data to the request body
                request.httpBody = jsonData
            } catch {
                print("Error encoding address:", error)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                        guard let self = self else { return }
                      
                if let error = error {
                    print("Request error:", error)
                    return
                }
                
                if let data = data {
                    // Parse the response JSON data
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let responseData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(UaddressResponse.self, from: responseData)
                                
                                print("Response message:", response.message )
                                print("Address ID:", response.address.addressId)
                                print("City:", response.address.city)
                                // Diğer adres alanlarını kullanabilirsiniz
                            }
                        }
                    } catch {
                        print("Error parsing JSON data:", error)
                    }

                }
            }
        
            // Start the URLSession task
            task.resume()
            
        }
        
    }
    
    
    func updateAddress(address: Address) {
        guard let url = URL(string: "http://localhost:8000/api/uploadAddresss") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(address)
            request.httpBody = jsonData
        } catch {
            print("Error encoding address:", error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Request error:", error)
                return
            }
            
            if let data = data {
                // Inside the URLSession.shared.dataTask completion handler
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(UaddressResponse.self, from: data)
                    
                    print("Response message:", response.message)
                    print("Address ID:", response.address.addressId)
                    print("City:", response.address.city)
                    // Access other address properties as needed
                } catch {
                    print("Error parsing JSON data:", error)
                }
            }
        }
        
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
