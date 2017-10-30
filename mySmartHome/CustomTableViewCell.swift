//
//  CustomTableViewCell.swift
//  mySmartHome
//
//  Created by Gudisi, Manjunath on 10/29/17.
//  Copyright © 2017 Gudisi Manjunath. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var textField1: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
