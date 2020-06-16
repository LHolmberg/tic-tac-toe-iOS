//
//  GameScene.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-14.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import SpriteKit
import FirebaseUI

class GridPiece {
    var x: Int
    var y: Int
    var sprite: SKSpriteNode
    
    init(x: Int, y: Int, sprite: String) {
        self.x = x
        self.y = y
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.position = CGPoint(x: self.x, y: self.y)
    }
}

class GameScene: SKScene {
    
    var gridPositions: [Int] = [0, 200,
                                0, 0,
                                0, -200,
                                200, 200,
                                200, -200,
                                -200, 0,
                                -200, 0,
                                -200, -200,
                                -200, 200]
    
    let winningCombinations = [[[0,200], [0,0], [0,-200]],
                               [[200,200], [200,0], [200,-200]],
                               [[-200,200], [-200,0], [-200,-200]],
                               [[-200,200], [0,200], [200,200]],
                               [[-200,0], [0,0], [200,0]],
                               [[-200,-200], [0,-200], [200,-200]],
                               [[-200,200], [0,0], [200,-200]],
                               [[200,200], [0,0], [-200,-200]]]
    
    var gridPieces: [GridPiece] = [GridPiece]()
    var gamePieces: [SKSpriteNode] = [SKSpriteNode]()
    var ID: Int = 0
    var turn: Int = 0
    enum Team {
        case ND
        case Square
        case Circle
    }
    
    var team: Team = Team.Square
    
    override func didMove(to view: SKView) {
        
        DataHandeler.instance.GetActiveGames { (arr, _) in
            let dict = arr[self.ID] as! [String: Any]
            
            DataHandeler.instance.GetUsername(email: dict["email"] as! String) { (username) in
                let label = SKLabelNode(text: "Opponent: " + username)
                label.fontSize = 30
                label.fontColor = UIColor.black
                label.fontName = "Avenir"
                label.position = CGPoint(x: 0, y: (self.view?.frame.size.height)! / 1.5)
                self.addChild(label)
            }
            if dict["team"] == nil {
                self.team = .Square
            } else {
                self.team = .Circle
            }
            
            if dict["turn"] != nil {
                self.turn = dict["turn"] as! Int
            }
            
            if let positions = dict["positions"] as? NSArray {
                for i in 0...10 {
                    if i % 2 == 0 {
                        self.gamePieces.append(SKSpriteNode(imageNamed: "x.png"))
                        self.gamePieces[i].name = String(i)
                        self.gamePieces[i].position = CGPoint(x: (positions[i] as! [Int])[0], y: (positions[i] as! [Int])[1])
                        self.gamePieces[i].scale(to: CGSize(width: 125, height: 125))
                        self.addChild(self.gamePieces[i])
                    } else {
                        self.gamePieces.append(SKSpriteNode(imageNamed: "o.png"))
                        self.gamePieces[i].name = String(i)
                        self.gamePieces[i].position = CGPoint(x: (positions[i] as! [Int])[0], y: (positions[i] as! [Int])[1])
                        self.gamePieces[i].scale(to: CGSize(width: 125, height: 125))
                        self.addChild(self.gamePieces[i])
                    }
                }
            } else if let positions = dict["positions"] as? [String: Any] {
                
                for i in 0...10 {
                    if i % 2 == 0 {
                        self.gamePieces.append(SKSpriteNode(imageNamed: "x.png"))
                        self.gamePieces[i].name = String(i)
                        self.gamePieces[i].position = CGPoint(x: (positions[String(i)] as! [Int])[0], y: (positions[String(i)] as! [Int])[1])
                        self.gamePieces[i].scale(to: CGSize(width: 125, height: 125))
                        self.addChild(self.gamePieces[i])
                    } else {
                        self.gamePieces.append(SKSpriteNode(imageNamed: "o.png"))
                        self.gamePieces[i].name = String(i)
                        self.gamePieces[i].position = CGPoint(x: (positions[String(i)] as! [Int])[0], y: (positions[String(i)] as! [Int])[1])
                        self.gamePieces[i].scale(to: CGSize(width: 125, height: 125))
                        self.addChild(self.gamePieces[i])
                    }
                }
            }
          
        }
        
        for i in 0...10 {
            gridPieces.append(GridPiece(x: gridPositions[i], y: gridPositions[i + 1], sprite: "sq.png"))
            gridPieces[i].sprite.scale(to: CGSize(width: 150, height: 150))
            self.addChild(gridPieces[i].sprite)
        }
    }
    
    func UpdatePosition(x: Int, y: Int, id: String) {
        let a = DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(self.ID)).child("positions")
        a.updateChildValues([id: [x,y]])
        
        DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(self.ID)).observeSingleEvent(of: .value) { (snapshot) in
            let temp = snapshot.value as! [String: Any]
            
            DataHandeler.instance.GetUserSnapshot { (userSnapshot) in
                for user in userSnapshot {
                    let dict = user.value as! [String: Any]
                    if dict["email"] as! String == temp["email"] as! String {
                        DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").observeSingleEvent(of: .value) { (snapshot) in
                            let dict2 = snapshot.value as! [[String: Any]]
                            for i in 0...dict2.count - 1 {
                                if dict2[i]["email"]! as! String == Auth.auth().currentUser!.email! {
                                    DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").child(String(i)).child("positions").updateChildValues([id: [x,y]])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func FinishedGame(result: String) {
        let a = DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(self.ID))
          a.observeSingleEvent(of: .value) { (snapshot) in
          
          let temp = snapshot.value as! [String: Any]
          DataHandeler.instance.GetUserSnapshot { (userSnapshot) in
                  for user in userSnapshot {
                      let dict = user.value as! [String: Any]
                      if dict["email"] as! String == temp["email"] as! String {
                          DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").observeSingleEvent(of: .value) { (snapshot) in
                              let dict2 = snapshot.value as! [[String: Any]]
                              for i in 0...dict2.count - 1 {
                                  if dict2[i]["email"]! as! String == Auth.auth().currentUser!.email! {
                                    DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").child(String(i)).removeValue()
                                    a.removeValue()
                                  }
                              }
                          }
                      }
                  }
              }
        }
        let vc = self.view?.window!.rootViewController as! Home
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        popover.result = result
        vc.addChild(popover)
        popover.view.frame = vc.view.frame
        vc.view.addSubview(popover.view)
        popover.didMove(toParent: vc)
    }
    
    func UpdateTurn(amount: Int) {
        let a = DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(self.ID))
        
        a.observeSingleEvent(of: .value) { (snapshot) in
            self.turn += amount
            
            let temp = snapshot.value as! [String: Any]
            a.updateChildValues(["turn": self.turn])
            
            DataHandeler.instance.GetUserSnapshot { (userSnapshot) in
                for user in userSnapshot {
                    let dict = user.value as! [String: Any]
                    if dict["email"] as! String == temp["email"] as! String {
                        DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").observeSingleEvent(of: .value) { (snapshot) in
                            let dict2 = snapshot.value as! [[String: Any]]
                            for i in 0...dict2.count - 1 {
                                if dict2[i]["email"]! as! String == Auth.auth().currentUser!.email! {
                                    DataHandeler.instance._REF_USERS_.child(user.key).child("active_games").child(String(i)).updateChildValues(["turn":self.turn])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func DidWin(completion: @escaping(Bool) -> Void)  {
        DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(self.ID)).child("positions").observeSingleEvent(of: .value) { (snapshot) in
            let pos = snapshot.value as! NSMutableArray
            for k in 0...self.winningCombinations.count - 1 {
                if self.turn % 2 == 0 {
                    for i in 0...pos.count - 1 {
                        if pos[i] as! [Int] == self.winningCombinations[k][0] && i % 2 == 0{
                            for n in 0...pos.count - 1 {
                                if pos[n] as! [Int] == self.winningCombinations[k][1] && n % 2 == 0{
                                    for x in 0...pos.count - 1 {
                                        if pos[x] as! [Int] == self.winningCombinations[k][2] && x % 2 == 0{
                                        completion(true)
                                    }
                                }
                            }
                        }
                    }
                    }
                } else {
                    for i in 0...pos.count - 1 {
                        if pos[i] as! [Int] == self.winningCombinations[k][0] && i % 2 != 0{
                            for n in 0...pos.count - 1 {
                                if pos[n] as! [Int] == self.winningCombinations[k][1] && n % 2 != 0{
                                    for x in 0...pos.count - 1 {
                                        if pos[x] as! [Int] == self.winningCombinations[k][2] && x % 2 != 0{
                                        completion(true)
                                    }
                                }
                            }
                        }
                    }
                    }
                }
            }
        }
        completion(false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when a touch begins
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if touchedNode.xScale == 0.5 {
                switch team {
                case .Circle:
                    if turn % 2 == 0 {
                        gamePieces[turn].position = touchedNode.position
                        self.UpdatePosition(x: Int(touchedNode.position.x), y: Int(touchedNode.position.y), id: String(turn))
                        UpdateTurn(amount: 1)
                        DidWin { (val) in
                            
                        }
                        let vc = self.view?.window!.rootViewController as! Home
                        vc.dismiss(animated: false, completion: nil)
                        
                        DidWin { (val) in
                            if val == true {
                                self.FinishedGame(result: "You won!")
                            }
                        }
                        
                        if turn == 8 {
                            FinishedGame(result: "The game was a tie!")
                        }
                        
                    }
                case .Square:
                    if turn % 2 != 0 {
                        gamePieces[turn].position = touchedNode.position
                        self.UpdatePosition(x: Int(touchedNode.position.x), y: Int(touchedNode.position.y), id: String(turn))
                        UpdateTurn(amount: 1)
                    
                        let vc = self.view?.window!.rootViewController as! Home
                        vc.dismiss(animated: false, completion: nil)
                        
                        DidWin { (val) in
                            if val == true {
                                self.FinishedGame(result: "You won!")
                            }
                        }
                        
                        if turn == 8 {
                            FinishedGame(result: "The game was a tie!")
                        }
                    }
                case .ND:
                    print("error")
                }
            }
        }
    }
}
