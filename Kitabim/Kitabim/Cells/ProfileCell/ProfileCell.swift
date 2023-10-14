//
//  ProfileCell.swift
//  Kitabim
//
//  Created by Zeynep Uzunsoy on 11.06.2023.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
