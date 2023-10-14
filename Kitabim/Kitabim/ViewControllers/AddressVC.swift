//
//  AddressVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import UIKit

class AddressVC: UIViewController {
    
    //    var addresses: [AddressResponse] = []
    var addresses: [Address] = []
    var isFirst: Bool = true
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
    
        tableView.register(UINib(nibName: String(describing: AddressCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AddressCell.self))
        
        fetchAddresses()
        tableView.reloadData()

        isFirst = false
                   
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFirst == false {
           fetchAddresses()
            tableView.reloadData()
        }
    }
    
    @IBAction func createAddressButtonClicked(_ sender: Any) {
       
        if let createAddressVC = storyboard?.instantiateViewController(withIdentifier: "CreateAddressVC") as? CreateAddressVC {
            navigationController?.pushViewController(createAddressVC, animated: true)
        }
        
    }
    
    
    func fetchAddresses() {
        guard let url = URL(string: "http://localhost:8000/api/address") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                       do {
                           let jsonDecoder = JSONDecoder()
                                         let response = try jsonDecoder.decode(AddressResponse.self, from: data)
                                         
                                         self.addresses = response.address
                                         
                                         DispatchQueue.main.async {
                                             self.tableView.reloadData()
                                         }
                       } catch {
                           print("Error decoding addresses: \(error)")
                       }
            }
        }
        
        task.resume()
    }
    
    
    
    func deleteAddress(addressId: Int) {
        guard let url = URL(string: "http://localhost:8000/deleteAddress/\(addressId)") else {
            print("Invalid URL")
            return
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Handle the response JSON
                        if let message = json["message"] as? String {
                            print("Response message:", message)
                            
                            // Display an alert or perform any UI update as needed
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
    
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }

    
}


extension AddressVC: UITableViewDataSource, UITableViewDelegate  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddressCell.self), for: indexPath) as? AddressCell else {
            return UITableViewCell()
        }

        let address = addresses[indexPath.row]
        let cityText = address.city ?? "" // Eğer city nil ise boş bir dize kullanılır
        let districtText = address.district ?? "" // Eğer district nil ise boş bir dize kullanılır
        addressCell.city.text = cityText + " " + districtText
        
        let name = address.name ?? ""
        let lastname = address.lastname ?? ""
        addressCell.name.text = name + " " + lastname
     
        addressCell.phoneNumber.text = address.phoneNumber
       
        addressCell.addressDescripton.text = address.address
        

        return addressCell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = addresses[indexPath.row]
        
        if let uploadAddressVC = storyboard?.instantiateViewController(withIdentifier: "UploadAddressVC") as? UploadAddressVC {
            uploadAddressVC.selectedAddress = selectedAddress
            navigationController?.pushViewController(uploadAddressVC, animated: true)
        }
    }


    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let address = addresses[indexPath.row]
                
                guard let addressId = address.addressId else {
                    return
                }
                
            deleteAddress(addressId: addressId)
            
            addresses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
                       
                
            showAlert(title: "Adres Silme", message: "Adres başarılı bir şekilde silindi.")
            }
    }
    
    
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


