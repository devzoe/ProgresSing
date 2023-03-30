//
//  SearchTableViewCell.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func get(data: String) {
        self.titleLabel.text = data
    }
    
}
