//
//  AdressCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var addressDescripton: UILabel!
    @IBOutlet weak var city: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
