//
//  InviteTVCell.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-13.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class InviteTVCell: UITableViewCell {
    
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
