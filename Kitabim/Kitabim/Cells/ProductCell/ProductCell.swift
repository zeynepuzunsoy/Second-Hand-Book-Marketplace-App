//
//  ProductCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 7.06.2023.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           productImage.image = nil
       }
}

