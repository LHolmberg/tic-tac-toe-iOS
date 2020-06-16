//
//  ActiveGameTVCell.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-12.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class ActiveGameTVCell: UITableViewCell {
    
    @IBOutlet weak var opponentTxt: UILabel!
    @IBOutlet weak var whosTurnTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
