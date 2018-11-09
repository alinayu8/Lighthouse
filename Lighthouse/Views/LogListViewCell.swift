//
//  LogListViewCell.swift
//  Lighthouse
//
//  Created by Alina Yu on 11/8/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import UIKit

class LogListViewCell: UITableViewCell {

    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryNotes: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
