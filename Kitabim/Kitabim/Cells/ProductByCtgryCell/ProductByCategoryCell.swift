//
//  ProductByCategoryCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import UIKit

class ProductByCategoryCell: UICollectionViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
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
