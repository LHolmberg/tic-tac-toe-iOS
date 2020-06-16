//
//  TicTacToeVC.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-14.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import SpriteKit

class TicTacToeVC: UIViewController {
    
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene(fileNamed:"TicTacToeScene") {
            // Configure the view.
            let skView = self.view as! SKView
            scene.ID = self.id
            scene.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
   
}
