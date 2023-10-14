//
//  CategoryVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 27.05.2023.
//

import UIKit
import Alamofire

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [Category] = []
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
               
        getCategory()
      
    }
    

    
    func getCategory(){
        AF.request("http://localhost:8000/api/home").responseDecodable(of: CategoryResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                   self.categories = apiResponse.categories
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
        
    }
   
    

    
    
    
}
extension CategoryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]

        
        if let productByCategoryVC = storyboard?.instantiateViewController(withIdentifier: "ProductByCategoryVC") as? ProductByCategoryVC {
            
            productByCategoryVC.categoryId = selectedCategory.category_id
            navigationController?.pushViewController(productByCategoryVC, animated: true)
        }
//           if let productByCategoryVC = storyboard?.instantiateViewController(withIdentifier: "ProductByCategoryVC") as? ProductByCategoryVC {
//               productByCategoryVC.categoryId = selectedCategory.category_id
//               present(productByCategoryVC, animated: true, completion: nil)
           }
    
    
}
