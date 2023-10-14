//
//  ProductByCategoryVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import UIKit
import Alamofire
import Kingfisher

class ProductByCategoryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var category : Category?
    var products : [Product] = []
    var imageURL : [URL] = []
    var categoryId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: String(describing: ProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductCell.self))
               
        
        collectionView.contentInsetAdjustmentBehavior = .always

       
        getProductsByCategory(categoryId: categoryId)
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if let categoryId = self.category?.category_id {
                beginAppearanceTransition(true, animated: animated)
                getProductsByCategory(categoryId: categoryId)
            }
        }
        

    

    
    func getProductsByCategory(categoryId: Int) {
        let url = "http://localhost:8000/api/getProductsByCategory/\(categoryId)"
            
            AF.request(url, method: .get).responseDecodable(of: Products.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    self.products = apiResponse.product
                    self.collectionView.reloadData()
                    print("Response: \(apiResponse)")
                    
                case .failure(let error):
                    // Hata durumunda yapılacak işlemler
                    print("Error: \(error)")
                }
            }
        }
    
    
 
    
    
}
    
extension ProductByCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
               let product = products[indexPath.item]
               cell.productName.text = product.name
        if let pricex = product.price {
            cell.price.text = "\(pricex) ₺"
        }
             //  cell.price.text = product.price

        cell.layer.applySketchShadow(color: UIColor.black, alpha: 0.1, x: 2, y:2 , blur: 10, spread: 0)
        
        

           if let productImages = product.images {
               for image in productImages {
                   if let imageURLString = image.imageURL,
                      let imageURL = URL(string: imageURLString) {
                       let options: KingfisherOptionsInfo = [.transition(.fade(0.2)), .cacheOriginalImage]
                       cell.productImage.kf.setImage(with: imageURL, options: options)
                   }
               }
           }
           
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

extension ProductByCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 25)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 0)
    }
    
}

