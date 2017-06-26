//
//  FriendTableViewCell.swift
//  WhosApp
//
//  Created by Zhiyuan Cui on 6/25/17.
//  Copyright © 2017 Zhiyuan Cui. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bindData(friend: String) {
        
        
        //Download user avatar and user name
        
        avatarImageView.layer.cornerRadius  = avatarImageView.frame.size.width / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.image = UIImage(named:"avatarPlaceholder")
        
        nameLabel.adjustsFontSizeToFitWidth = true;
        nameLabel.minimumScaleFactor = 0.5
        
        nameLabel.text = "user.name"
        
        
    }

}
