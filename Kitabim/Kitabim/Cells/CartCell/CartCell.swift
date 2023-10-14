//
//  CartCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 9.06.2023.
//

import UIKit

class CartCell: UITableViewCell {
    
    //    weak var delegate: CartCellDelegate?
    //      var indexPath: IndexPa
    
    var cartDetailId : Int?
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
}

