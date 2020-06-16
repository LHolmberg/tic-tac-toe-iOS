//
//  ResultVC.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-16.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var resultTxt: UILabel!
    
    var result: String = String()
    
    @IBAction func OkBtn(_ sender: Any) {
        let parent = self.parent as! Home
        parent.viewWillAppear(true)
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        resultTxt.text = self.result
    }
}
