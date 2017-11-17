//
//  medicineTableViewCell.swift
//  Luna
//
//  Created by 卢晓航 on 2017/11/17.
//  Copyright © 2017年 jacob inc. All rights reserved.
//

import UIKit

class medicineTableViewCell: UITableViewCell {

    @IBOutlet weak var Frequency: UILabel!
    @IBOutlet weak var dosage: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var medicinename: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
