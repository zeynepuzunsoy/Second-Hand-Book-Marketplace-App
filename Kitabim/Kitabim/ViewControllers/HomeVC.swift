//
//  HomeVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 20.03.2023.
//

import UIKit
import Alamofire
import Kingfisher


class HomeVC: UIViewController {
    
    @IBOutlet weak var productCollection: UICollectionView!
    
    var imageURL : [URL] = []
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productCollection.delegate = self
        productCollection.dataSource = self
        
        productCollection.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
//        productCollection.showsHorizontalScrollIndicator = false //scroll çubuğunu gizle
        
        processJSONData()
                
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         processJSONData()
         productCollection.reloadData()
     }
    

    

    
    @IBAction func createProductButton(_ sender: Any) {
        
        if let createProductVC = storyboard?.instantiateViewController(withIdentifier: "CreateProductVC") as? CreateProductVC {
            navigationController?.pushViewController(createProductVC, animated: true)
        }
        
    }
    
    
    
    
    
    
    func processJSONData() {
        
        guard let apiUrl = URL(string: "http://localhost:8000/api/getAllProducts") else {
            print("Geçersiz API URL'si")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        if let dataToken = UserDefaults.standard.string(forKey: "isLoggedIn") {
            let bearerToken = "Bearer \(dataToken)"
            request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("API isteği hatası: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Geçersiz HTTP yanıtı")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Hatalı API yanıtı: \(httpResponse.statusCode)")
                return
            }
            
            guard let jsonData = data else {
                print("API yanıtı içermiyor")
                return
            }
            
            do {
                // JSON verisini parse etme
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                
                // product dizisini alma
                guard let productArray = json?["product"] as? [[String: Any]] else {
                    print("JSON verisinde 'product' dizisi bulunamadı")
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: productArray, options: [])
                    let decoder = JSONDecoder()
                    let products = try decoder.decode([Product].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.products = products
                        self.productCollection.reloadData()
                    }
                    
                } catch {
                    print("JSON decode hatası: \(error)")
                }
                
                for product in productArray {
                    // İlgili verileri alma
                    if let productId = product["product_id"] as? Int,
                       let userId = product["user_id"] as? Int,
                       let categoryId = product["category_id"] as? Int,
                       let name = product["name"] as? String,
                       let price = product["price"] as? String,
                       let description = product["description"] as? String,
                       let isActive = product["is_active"] as? Int,
                       let createdAt = product["created_at"] as? String,
                       let updatedAt = product["updated_at"] as? String,
                       let images = product["images"] as? [[String: Any]] {
                        
                        // İşlemleri gerçekleştirme
                        print("Ürün ID: \(productId)")
                        print("Kullanıcı ID: \(userId)")
                        print("Kategori ID: \(categoryId)")
                        print("Ürün Adı: \(name)")
                        print("Fiyat: \(price)")
                        print("Açıklama: \(description)")
                        print("Aktif mi?: \(isActive)")
                        print("Oluşturulma Tarihi: \(createdAt)")
                        print("Güncellenme Tarihi: \(updatedAt)")
                        
                        // Resimleri ayırma
                        for image in images {
                                    if let imageUrlString = image["image_url"] as? String,
                                       let url = URL(string: imageUrlString) {
                                       print("Resim URL: \(imageUrlString)") // Resim URL'sini doğrula
                                       self.imageURL.append(url)
                                    }
                        }
                    }
                    
                }
                DispatchQueue.main.async {
                            self.productCollection.reloadData()
                        }
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
        let product = products[indexPath.item]
        cell.productName.text = product.name
        if let pricex = product.price {
            cell.price.text = "\(pricex) ₺" }
        
        let image = imageURL[indexPath.item]
        
        cell.layer.applySketchShadow(color: UIColor.black, alpha: 0.1, x: 2, y:2 , blur: 10, spread: 0)
        


        
        let options: KingfisherOptionsInfo = [.transition(.fade(0.2)), .cacheOriginalImage]
        cell.productImage.kf.setImage(with: image, options: options)
//        cell.productImage.kf.setImage(with: image)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        
        if let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
            
            productDetailVC.product = selectedProduct
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }

}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 25)
    }
    
}






