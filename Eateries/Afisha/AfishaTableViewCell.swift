//
//  AfishaTableViewCell.swift
//  Eateries
//
//  Created by Хакан Абулов on 05/12/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class AfishaTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
