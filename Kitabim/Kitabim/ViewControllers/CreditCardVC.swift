//
//  CreditCardVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 13.06.2023.
//

import UIKit

class CreditCardVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var isFirst: Bool = true
    var creditCards: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: String(describing: CreditCardCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CreditCardCell.self))
        
        tableView.reloadData()

        isFirst = false
                   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFirst == false {
            getCreditCard()
            tableView.reloadData()
        }
    }
    
    @IBAction func createCardButtonClicked(_ sender: Any) {
        if let createcardVC = storyboard?.instantiateViewController(withIdentifier: "CreateCreditCardVC") as? CreateCreditCardVC {
            navigationController?.pushViewController(createcardVC, animated: true)
        }
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
                    self.tableView.reloadData()
                }
  
            } catch {
                print("JSON verisi işlenirken hata oluştu: \(error)")
            }

                }
        
        task.resume()
    }
    
    
    func deleteCreditCard(creditCardId: Int) {
        guard let url = URL(string: "http://localhost:8000/api//deleteCreditCard/\(creditCardId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // Add authentication token to the request header if necessary
        if let token = UserDefaults.standard.string(forKey: "isLoggedIn") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error:", error)
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data {
                        do {
                            
                            let decoder = JSONDecoder()
                            let deleteResponse = try decoder.decode(DeleteResponse.self, from: data)
                            let message = deleteResponse.message
                            print("Response message:", message)
                        } catch {
                            print("Error parsing JSON data:", error)
                        }
                    }
                } else if response.statusCode == 404 {
                    print("Credit card not found")
                } else {
                    print("Unexpected status code:", response.statusCode)
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


extension CreditCardVC: UITableViewDataSource, UITableViewDelegate  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CreditCardCell.self), for: indexPath) as? CreditCardCell else {
            return UITableViewCell()
        }
        // Kredi kartı bilgilerini alın
        
//        let creditCard = creditCards[indexPath.row]
//
//        cell.name.text =  "Ad Soyad : \(String(describing: creditCard.name) )"
//        cell.cardNo.text = "Kart Numarası: \(creditCard.cardNo)"
//            cell.expire.text = "Ay/Yıl :\(creditCard.expireMonth ?? "")/\(creditCard.expireYear ?? "")"
//            cell.cvc.text =  "CVC : \(String(describinf: creditCard.cvc))"
//
        let creditCard = creditCards[indexPath.row]
        
        cell.name.text = "Ad Soyad: \(creditCard.name ?? "")"
        cell.cardNo.text = "Kart Numarası: \(creditCard.cardNo ?? "")"
        cell.expire.text = "Ay/Yıl: \(creditCard.expireMonth ?? "")/\(creditCard.expireYear ?? "")"
        cell.cvc.text = "CVC: \(creditCard.cvc ?? "")"

//
            return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedAddress = addresses[indexPath.row]
//
//        if let uploadAddressVC = storyboard?.instantiateViewController(withIdentifier: "UploadAddressVC") as? UploadAddressVC {
//            uploadAddressVC.selectedAddress = selectedAddress
//            navigationController?.pushViewController(uploadAddressVC, animated: true)
//        }
    }


    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let card = creditCards[indexPath.row]

            guard let cardId = card.creditCardId else {
                    return
                }

                deleteCreditCard(creditCardId: cardId)

                creditCards.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                showAlert(title: "Kredi Kartı Silme", message: "Kredi kartı başarılı bir şekilde silindi.")
            }
    }
    
    
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}



