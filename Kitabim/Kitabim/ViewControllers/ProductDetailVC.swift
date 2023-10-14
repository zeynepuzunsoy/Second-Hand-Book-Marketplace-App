//
//  ProductDetailVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 9.06.2023.
//

import UIKit
import Alamofire

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    var imageURL : [URL] = []
    var categories: [Category] = []
    var product: Product?
    var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let product = product {
            productName.text = product.name
            if let pricex = product.price {
                price.text = "\(pricex) ₺"
//                let priceText = "\(pricex) ₺"
//                price.text = String(pricex) + " TL"
            } else {
                price.text = "Price unavailable"
            }
            productDescription.text = product.description
            
            
            
            
            getCategory { [weak self] in
                if let categoryName = self?.getCategoryName(categoryID: product.categoryID) {
                    self?.category.text = "Kategori : \(categoryName)"
                }
            }
            
            getUser {
                [weak self] in
                if let userName = self?.getUserName(userID: product.userID) {
                    self?.username.text = "Satıcı: \(userName)"
                }
            }
            
        

            
            if let images = product.images, let imageUrlString = images.first?.imageURL, let url = URL(string: imageUrlString) {
                productImage.kf.setImage(with: url)
            }
           
            
        }
        

        
        
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        guard let productID = self.product?.productID else {
                print("Hata: productID nil olarak belirlenmiş.")
                return
            }
        
        let quantity = 1
        
            addToCart(productID: productID, quantity: quantity) { result in
                switch result {
                case .success(let responseString):
                    print("Response: \(responseString)")
                    self.showAlert(title: "Başarılı" , message: "Ürün sepete başarı ile yüklendi")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        
    }
    
    func getCategoryName(categoryID: Int?) -> String? {
        if let categoryID = categoryID, let category = categories.first(where: { $0.category_id == categoryID }) {
            return category.name
        }
        return nil
    }
    
    func getUserName(userID: Int?) -> String? {
        if let userID = userID, let user = users.first(where: { $0.userID == userID }) {
            return user.name
        }
        return nil
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
    
    func getUser(completion: @escaping () -> Void) {
        AF.request("http://localhost:8000/api/home").responseDecodable(of: CategoryResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                self.users = apiResponse.users
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
   
    func addToCart(productID: Int, quantity: Int, completion: @escaping (Result<CartResponse, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: "isLoggedIn") else {
            let error = NSError(domain: "Access Token not found", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        let bearerToken = "Bearer \(accessToken)"

        guard let url = URL(string: "http://localhost:8000/api/cart/add") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "product_id": productID,
            "quantity": quantity
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let cartResponse = try decoder.decode(CartResponse.self, from: data)
                    completion(.success(cartResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "Invalid Response", code: 0, userInfo: nil)
                completion(.failure(error))
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

