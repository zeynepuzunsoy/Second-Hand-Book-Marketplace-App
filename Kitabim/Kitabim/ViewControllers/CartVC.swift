//
//  BasketVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 29.05.2023.
//

import UIKit
import Alamofire

class CartVC: UIViewController {

    var cartResponse : [CartResponse] = []
    var product: [Product] = []
    var imageURL : [URL] = []
    var cartDetails: [CartDetailResponse] = []
    var categories: [Category] = []
    var isFirst: Bool = true

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")

        tableView.dataSource = self
        tableView.delegate = self
        

        fetchCartData()
        
        tableView.reloadData()
        isFirst = false
                   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFirst == false {
            fetchCartData()
            tableView.reloadData()
        }
    }
 

    @IBAction func payButtonClicked(_ sender: Any) {
        if cartDetails.isEmpty {
                   showAlert(title: "Sepet Boş", message: "Ödeme yapabilmek için sepetinizi doldurun.")
               } else {
                if let paymentVC = storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC {
                    navigationController?.pushViewController(paymentVC, animated: true)
                }
               }
    }
    
 
    func fetchCartData() {
        guard let accessToken = UserDefaults.standard.string(forKey: "isLoggedIn") else {
            // Eğer kullanıcı giriş yapmamışsa uygun bir işlem yapabilirsiniz
            return
        }

        let bearerToken = "Bearer \(accessToken)"

        guard let url = URL(string: "http://localhost:8000/api/cart") else {
            print("Geçersiz URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Hata: \(error)")
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let cartResponse = try decoder.decode(CartResponse.self, from: data)
                    DispatchQueue.main.async {
//                        self.cartResponse.append(cartResponse)
                        self.cartResponse = [cartResponse]
                        self.cartDetails = cartResponse.details ?? []
                        self.fetchProductDetails()
                        self.calculateTotalPrice()
                        self.tableView.reloadData()
                      
                    }

                } catch {
                    print("Hata: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func fetchProductDetails() {
        guard !cartResponse.isEmpty else { return }

        for cartResponse in cartResponse {
            if let details = cartResponse.details {
                let productIds = details.compactMap { $0.productID }
                let productIdStrings = productIds.map { "\($0)" }
                getProductDetails(productIds: productIdStrings) { [weak self] products in
                    DispatchQueue.main.async {
                        
                        self?.product = products
                        self?.tableView.reloadData()
                        self?.product.removeAll()
                        self?.product.append(contentsOf: products)
                        self?.calculateTotalPrice()
                        self?.tableView.reloadData()
                       
                               
                    }
                }
            }
        }
    }
    
    func getCategoryName(categoryID: Int?) -> String? {
        if let categoryID = categoryID, let category = categories.first(where: { $0.category_id == categoryID }) {
            return category.name
        }
        return nil
    }


    func getProductDetails(productIds: [String], completion: @escaping ([Product]) -> Void) {
        let group = DispatchGroup()
        var products: [Product] = []

        for productId in productIds {
            group.enter()
            let urlString = "http://localhost:8000/api/getProductDetails/\(productId)"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                group.leave()
                continue
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            guard let accessToken = UserDefaults.standard.string(forKey: "isLoggedIn") else {
                // Eğer kullanıcı giriş yapmamışsa uygun bir işlem yapabilirsiniz
                return
            }

          
            let bearerToken = "Bearer \(accessToken)"
            request.addValue(bearerToken, forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    group.leave()
                }

                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let productDict = json as? [String: Any],
                          let productData = try? JSONSerialization.data(withJSONObject: productDict, options: []),
                          let product = try? JSONDecoder().decode(Product.self, from: productData) else {
                        print("Failed to decode product data")
                        return
                    }

                    products.append(product)
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }

            task.resume()
        }

        group.notify(queue: DispatchQueue.main) {
            completion(products)
        }
    }
    
    
    func deleteCartItem(cartDetailId: Int) {

        let apiUrl = "http://localhost:8000/api/remove"
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
        
        // İstek için JSON verilerini oluşturun
        let parameters: [String: Any] = [
            "cart_detail_id": cartDetailId
        ]
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("İstek verilerini oluştururken hata oluştu")
            return
        }
        request.httpBody = requestData
        
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
            
            // Yanıtı JSON olarak ayrıştırma
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let responseJson = json as? [String: Any] {
                // İşlemleri burada yapın
                
                // Örneğin, güncellenen sepeti alın
                if let updatedCart = responseJson["cart"] as? [String: Any] {
                    // TableView'inizi güncelleyin
                    print("Güncellenen Sepet: \(updatedCart)")
                }
            } else {
                print("Geçersiz JSON yanıtı")
            }
        }
        task.resume()
    }
    
    func getCategory(completion: @escaping () -> Void) {
        AF.request("http://localhost:8000/api/home").responseDecodable(of: CategoryResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                self.categories = apiResponse.categories
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0.0

        for cartDetail in cartDetails {
            if let productID = cartDetail.productID {
                for product in self.product {
                    if product.productID == productID, let priceString = product.price, let price = Double(priceString) {
                        totalPrice += price
                    }
                }
            }
        }

        let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           formatter.locale = Locale(identifier: "tr_TR") // Set the locale to Turkey (tr_TR)
           formatter.currencySymbol = "" // Empty currency symbol
           let totalFormatted = formatter.string(from: NSNumber(value: totalPrice))
           
           if let formattedPrice = totalFormatted {
               let priceWithSymbol = formattedPrice + " TL" // Append " TL" to the end of the price
               priceLabel.text = priceWithSymbol
           } else {
               priceLabel.text = "" // Handle the case where formatting fails
           }

    }



    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
}

extension CartVC: UITableViewDataSource, UITableViewDelegate  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell


        
        let product = product[indexPath.row]
        cell.productName.text = product.name
        if let pricex = product.price {
            cell.price.text = "\(pricex) ₺"
        
        }
       
        self.getCategory { [weak self] in
            if let categoryName = self?.getCategoryName(categoryID: product.categoryID) {
                cell.category.text = "Kategori : \(categoryName)"
            }
        }
        


        if let imageURL = product.images?.first?.imageURL,
           let url = URL(string: imageURL) {
            cell.productImage.kf.setImage(with: url)
        }

        return cell
    }
 
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        
        if editingStyle == .delete {
                   let cartDetail = cartDetails[indexPath.row]
            
                   guard let cartDetailId = cartDetail.cartDetailID else {
                       return
                   }
                   
                   deleteCartItem(cartDetailId: cartDetailId)
                   
            cartDetails.remove(at: indexPath.row)
            
          
            self.product.remove(at: indexPath.row)
                   
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.calculateTotalPrice()
               }
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}






