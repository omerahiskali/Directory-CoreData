//
//  TableViewCell.swift
//  CoreDataProject
//
//  Created by Ömer Faruk Küçükahıskalı on 18.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var etiket: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
