//
//  UserRepositioresTableViewCell.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import UIKit

class UserRepositioresTableViewCell: UITableViewCell {

    @IBOutlet weak var LBLRepoName: UILabel!
    @IBOutlet weak var LBLRepoDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
