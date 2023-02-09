//
//  ChartTableViewCell.swift
//  ProgresSing
//
//  Created by 남경민 on 2023/02/10.
//

import UIKit

class ChartTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func get(data: Chart) {
        DispatchQueue.main.async {
            self.playButton.setCornerRadius(5)
        }
        self.albumImageView.image = UIImage(named: data.imageName)
        self.rankLabel.text = data.rank
        self.titleLabel.text = data.title
        self.artistLabel.text = data.artist
    }
    
}
