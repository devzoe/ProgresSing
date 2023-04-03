//
//  RankingTableViewCell.swift
//  UpSing
//
//  Created by 남경민 on 2023/03/30.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
 
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
       // self.userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func get(index: Int, data : Ranking) {
      //  userImageView.image = UIImage(named: "default_profile")
        rankLabel.text = String(index)
        nicknameLabel.text = data.nickname
        print(data.nickname)
        scoreLabel.text = String(data.score)
        print(data.score)
    }
}
