//
//  PaymentVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 10.06.2023.
//

import UIKit

class PaymentVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var creditcard: UITextField!
    @IBOutlet weak var address: UITextField!
    var payment : [PaymentResponse] = []
    var addresses: [Address] = []
    var creditCards: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        address.delegate = self
        creditcard.delegate = self
        
        fetchAddresses()
        getCreditCard()
        
        totalPrice.text = ""
    
        }
   
    
    @IBAction func checkoutButtonClicked(_ sender: Any) {
        self.showAlert(title: "Ödeme Başarılı", message: "Siparişiniz başarıyla gerçekleştirildi.")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
   
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField ==  {
//            showAddressSelection()
//            return false
//        }
//        return true
//    }
//    
    
    
    func checkout() {
        let apiUrl = "http://localhost:8000/api/checkout"
        guard let url = URL(string: apiUrl) else {
            print("Geçersiz API URL'si")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let accessToken = UserDefaults.standard.string(forKey: "isLoggedIn") else {
            // Eğer kullanıcı giriş yapmamışsa uygun bir işlem yapabilirsiniz
            return
        }
        
        let bearerToken = "Bearer \(accessToken)"
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // İstek gönderme
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Yanıtı işleme
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Boş yanıt alındı")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let payment = try decoder.decode(PaymentResponse.self, from: data)
                DispatchQueue.main.async {
                    self.payment.append(payment)
//                    if let totalPrice = payment.totalPrice {
//                        self.totalPrice.text = "\(totalPrice) TL"
//                    } else {
//                        self.totalPrice.text = ""
//                    }

                   
                }
            } catch {
                print("Hata: \(error)")
                self.showAlert(title: "Ödeme Hatası", message: "Ödeme işlemi sırasında bir hata oluştu.")
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
//                                             self.tableView.reloadData()
                                         }
                       } catch {
                           print("Error decoding addresses: \(error)")
                       }
            }
        }
        
        task.resume()
    }
    func getCreditCard() {
        guard let url = URL(string: "http://localhost:8000/api/creditCard") else {
            print("Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                        print("Hata: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = data else {
                        print("Veri alınamadı")
                        return
                    }
            do {
                let decoder = JSONDecoder()
                let creditCardResponse = try decoder.decode(CreditCardResponse.self, from: data)
                self.creditCards = creditCardResponse.creditCard
                DispatchQueue.main.async {
//                    self.tableView.reloadData()
                }
  
            } catch {
                print("JSON verisi işlenirken hata oluştu: \(error)")
            }

                }
        
        task.resume()
    }
    
}


extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Tablonun satır sayısını döndürün
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        let address = addresses[indexPath.row]
        // Hücreyi güncelleyin
        cell.textLabel?.text = address.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = addresses[indexPath.row]
        address.text = selectedAddress.address
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == address {
            showAddressSelection()
            return false
        } else if textField == creditcard {
            showCardSelection()
            return false
        }
        return true
    }
    
    func showAddressSelection() {
        let alertController = UIAlertController(title: "Adres Seç", message: nil, preferredStyle: .actionSheet)
        
        for address in addresses {
            let action = UIAlertAction(title: address.name, style: .default) { [weak self] _ in
                self?.address.text = address.address
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showCardSelection() {
        let alertController = UIAlertController(title: "Kart Seç", message: nil, preferredStyle: .actionSheet)
        
        for card in creditCards {
            let action = UIAlertAction(title: card.cardNo, style: .default) { [weak self] _ in
                self?.creditcard.text = card.name
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
