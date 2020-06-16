//
//  SearchUserVC.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-13.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class SearchUserVC: UIViewController {
    
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBAction func Dismiss(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func InviteBtn(_ sender: Any) {
        if searchTxt.text != "" {
            DataHandeler.instance.SendInvite(username: searchTxt.text!) { (success) in
                if success == true {
                    self.view.removeFromSuperview()
                } else {
                    print("Error inviting")
                }
            }
        } else {
            print("Enter a username")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        searchTxt.becomeFirstResponder()
    }
}
