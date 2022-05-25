//
//  UserTableViewCell.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblFullname : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(user : DataModel?){
        if user != nil {
            imgUser.downloaded(from: user!.avatar)
            lblFullname.text = user!.first_name + " " + user!.last_name
            lblEmail.text = user!.email
        }
        
    }
    
    override func layoutSubviews() {
        imgUser.layer.masksToBounds = true
        imgUser.layer.cornerRadius = imgUser.bounds.width / 2
    }
    
}
