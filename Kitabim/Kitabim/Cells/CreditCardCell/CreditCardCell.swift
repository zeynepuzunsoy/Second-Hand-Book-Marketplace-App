//
//  CreditCardCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 13.06.2023.
//

import UIKit

class CreditCardCell: UITableViewCell {

    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var expire: UILabel!
    @IBOutlet weak var cvc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
