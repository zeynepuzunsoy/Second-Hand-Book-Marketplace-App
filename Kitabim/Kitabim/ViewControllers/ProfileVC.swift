//
//  ProfileVC.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 29.05.2023.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    let sections = ["Adreslerim", "Ürünlerim", "Kartlarım"]
    let sectionIcons = ["address_icon", "products_icon", "cards_icon"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        switch indexPath.row {
          case 0:
              cell.textLabel?.text = "Adreslerim"
          case 1:
            cell.textLabel?.text = "Kartlarım"
          case 2:
            cell.textLabel?.text = "Çıkış Yap"
          default:
              break
          }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Seçilen hücreye göre ilgili işlemi yapabilirsiniz
        let section = indexPath.row
        switch section {
        case 0:
            if let address = storyboard?.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
                navigationController?.pushViewController(address, animated: true)
            }
            break
        case 1:
            if let card = storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as? CreditCardVC {
                navigationController?.pushViewController(card, animated: true)
            }
            break
        case 2:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
