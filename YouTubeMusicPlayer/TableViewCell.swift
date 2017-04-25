//
//  TableViewCell.swift
//  YouTubeMusicPlayer
//
//  Created by Himaja Motheram on 4/22/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    
    
    @IBOutlet weak var videoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
