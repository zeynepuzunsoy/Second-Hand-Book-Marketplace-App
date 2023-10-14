//
//  CreateProductVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 5.06.2023.
//

import UIKit
import Alamofire
import Foundation


class CreateProductVC: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    var selectedImages: [UIImage] = []
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryTextField.delegate = self
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        imagesCollectionView.register(UINib(nibName: String(describing: ProductImageCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProductImageCell.self))
        imagesCollectionView.showsHorizontalScrollIndicator = false //scroll çubuğunu gizle
        
        
        getCategory()
        
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        
        let name = nameTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        
        if let categoryID = getCategoryID(categoryName: category) {
            let categoryIDString = String(categoryID)
            
            
            uploadProduct2(name: name, categoryID: categoryIDString , price: price, description: description, images: selectedImages)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getCategoryID(categoryName: String) -> Int? {
        if let category = categories.first(where: { $0.name == categoryName }) {
            return category.category_id
        }
        return nil
    }
}
    
    
    
    
    extension CreateProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            selectedImages.append(image)
            
            imagesCollectionView.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        
        func sendImageDataToAPI(image: [UIImage], name: String, price: String, description: String, categoryId: String) {
            for img in image {
                if let imageData = img.jpegData(compressionQuality: 0.8) {
                    // Görüntü verisi alındı, burada yapılacak işlemler
                } else {
                    print("Görüntü verisi alınamadı.")
                }
            }
            
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken"){
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)",
                    "Accept": "multipart/form-data"
                ]
                
                let url = "http://localhost:8000/api/createProduct"
                
                AF.upload(
                    multipartFormData: { multipartFormData in
                        for (index, image) in self.selectedImages.enumerated() {
                            if let imageData = image.jpegData(compressionQuality: 0.8) {
                                multipartFormData.append(imageData, withName: "images[]", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
                            }
                        }
                        multipartFormData.append(Data(name.utf8), withName: "name")
                        multipartFormData.append(Data(price.utf8), withName: "price")
                        multipartFormData.append(Data(description.utf8), withName: "description")
                        multipartFormData.append(Data(categoryId.utf8), withName: "category_id")
                    },
                    to: url,
                    headers: headers
                )
                .responseDecodable(of: ProductResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        print("Yanıt: \(value)")
                        // Yanıt verisini işleme devam edin...
                    case .failure(let error):
                        print("Hata: \(error)")
                        // Hata durumunu işleme devam edin...
                    }
                }
                
               
            }
        }
    }

    
    
    extension CreateProductVC: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return selectedImages.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let productImageCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductImageCell.self), for: indexPath) as? ProductImageCell else {
                return UICollectionViewCell()
            }
            
            productImageCell.productImageView.image = selectedImages[indexPath.item]
            print(selectedImages)
            
            return productImageCell
        }
        
        
        
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField == categoryTextField {
                showCategorySelection()
                return false
            }
            return true
        }
        
        
        
        func showCategorySelection() {
            let alertController = UIAlertController(title: "Kategori Seç", message: nil, preferredStyle: .actionSheet)
            
            for category in categories {
                let action = UIAlertAction(title: category.name, style: .default) { [weak self] _ in
                    self?.categoryTextField.text = category.name
                }
                alertController.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        
        func getCategory(){
            AF.request("http://localhost:8000/api/home").responseDecodable(of: CategoryResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    self.categories = apiResponse.categories
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
     
                
                    func uploadProduct2(name: String, categoryID: String, price: String, description: String, images: [UIImage]) {
                        guard let DataToken = UserDefaults.standard.string(forKey: "isLoggedIn") else {
                            print("Erişim belirteci (accessToken) bulunamadı.")
                            return
                        }
                        do {
                            //
                            print("Bearer Token: \(DataToken)")
                            
                            let bearerToken = "Bearer \(DataToken)"
                            
                            
                            let url = URL(string: "http://localhost:8000/api/createProduct")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
                            
                            let boundary = UUID().uuidString
                            let contentType = "multipart/form-data; boundary=\(boundary)"
                            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                            
                            let body = NSMutableData()
                            
                            // Parameters
                            let parameters = [
                                "name": name,
                                "category_id": String(categoryID),
                                "price": String(price),
                                "description": description
                            ]
                            
                            for (key, value) in parameters {
                                body.appendString("--\(boundary)\r\n")
                                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                                body.appendString("\(value)\r\n")
                            }
                            
                            // Images
                            for (index, image) in images.enumerated() {
                                if let imageData = image.jpegData(compressionQuality: 0.8) {
        
                                    body.appendString("--\(boundary)\r\n")
                                    body.appendString("Content-Disposition: form-data; name=\"images[\(index)]\"; filename=\"image\(index).jpeg\"\r\n")
                                    body.appendString("Content-Type: image/jpeg\r\n\r\n")
                                    body.append(imageData)
                                    body.appendString("\r\n")
                                }
                                else {
                                    print("Unable to generate JPEG data for image \(index).")
                                }
                            }
                            
                            body.appendString("--\(boundary)--\r\n")
                            
                            request.httpBody = body as Data
                            
                            
                            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                    return
                                }
                                
                                if let response = response as? HTTPURLResponse {
                                    print("Status code: \(response.statusCode)")
                                }
                                
                                if let data = data {
                                    // Handle response data
                                    do {
                                        let decoder = JSONDecoder()
                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                        let responseModel = try decoder.decode(ProductResponse.self, from: data)
                                        print("Response: \(responseModel)")
                                     
                                
                                    } catch let decodingError {
                                        print("Error decoding JSON: \(decodingError)")
                                        
                                        if let responseString = String(data: data, encoding: .utf8) {
                                            print("Response: \(responseString)")
                                        }
                                    }
                                    
                                    if let responseString = String(data: data, encoding: .utf8) {
                                        print("Response: \(responseString)")
                                    }

                                }
                                
                            
                            }
                            
                            task.resume()
                            
                            
                        } catch {
                            print("Erişim belirteci çözümlenirken bir hata oluştu: \(error)")
                        }
                        
                       
                        
                    }

                    }
                    
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            append(data)
        }
    }
}
                        
 
                        
                        func uploadProduct(name: String, categoryID: Int, price: Int, description: String, images: [UIImage]) {
                            let url = "http://localhost:8000/api/createProduct"
                            let headers: HTTPHeaders = [
                                "Content-Type": "multipart/form-data"
                            ]
                            
                            AF.upload(multipartFormData: { multipartFormData in
                                multipartFormData.append(Data(name.utf8), withName: "name")
                                multipartFormData.append(Data("\(categoryID)".utf8), withName: "category_id")
                                multipartFormData.append(Data("\(price)".utf8), withName: "price")
                                multipartFormData.append(Data(description.utf8), withName: "description")
                                
                                for (index, image) in images.enumerated() {
                                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                                        multipartFormData.append(imageData, withName: "images[]", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
                                    }
                                }
                            }, to: url, method: .post, headers: headers)
                            .responseDecodable(of: ProductResponse.self) { response in
                                switch response.result {
                                case .success(let data):
//                                    self.navigationController?.popToRootViewController(animated: true)
                                    print(data)
                                case .failure(let error):
                                    if let decodingError = error.underlyingError as? DecodingError {
                                        switch decodingError {
                                        case .keyNotFound(let key, _):
                                            print("Required key not found in response: \(key.stringValue)")
                                        default:
                                            print("Failed to decode response: \(decodingError)")
                                        }
                                    } else {
                                        print("Request failed: \(error)")
                                    }
                                }
                            }
                        }
                    
                
     
                    
            
            
        
    
    

