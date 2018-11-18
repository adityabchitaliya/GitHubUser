//
//  userDetailTableViewCell.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import UIKit

class userDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageVIew: UIImageView!
    @IBOutlet weak var LBLUserName: UILabel!
    @IBOutlet weak var LBLUserUrl: UILabel!
    @IBOutlet weak var LBLUserSubscriptions: UILabel!
    @IBOutlet weak var LBLUserSubscriptionsValue: UILabel!
    @IBOutlet weak var LBLUserorganization: UILabel!
    @IBOutlet weak var LBLUserorganizationValue: UILabel!
    @IBOutlet weak var BtnExpandCellOutlet: UIButton!
    @IBOutlet weak var ImgUserAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
