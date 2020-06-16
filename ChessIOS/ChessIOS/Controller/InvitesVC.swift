//
//  InvitesVC.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-13.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit
import FirebaseUI

class InvitesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var tempArr: NSMutableArray = []
    var refreshControl = UIRefreshControl()
           
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController 
        DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.value(forKey: "uid") as! String).child("invites").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? NSArray {
                self.tempArr = snap as! NSMutableArray
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
      @objc func refresh(_ sender: AnyObject) {
          
        DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.value(forKey: "uid") as! String).child("invites").observeSingleEvent(of: .value) { (snapshot) in
               if let snap = snapshot.value as? NSArray {
                   self.tempArr = snap as! NSMutableArray
                   self.tableView.reloadData()
               }
        }
          
          refreshControl.endRefreshing()
      }
    
    @IBAction func Dismiss(_ sender: Any) {
        let parent = self.parent as! Home
        parent.viewWillAppear(true)
        self.view.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteTVCell", for: indexPath as IndexPath) as! InviteTVCell
       
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(AcceptInvite), for: .touchUpInside)
        
        cell.declineBtn.tag = indexPath.row
        cell.declineBtn.addTarget(self, action: #selector(DeclineInvite), for: .touchUpInside)
    
        let dict = tempArr[indexPath.row] as! [String: String]
        DataHandeler.instance.GetUsername(email: dict["email"]!) { (username) in
            cell.usernameTxt.text = username
        }
        
        return cell
    }
    
    @objc func AcceptInvite(sender: UIButton) {
        let val: [String: Any] = ["email": Auth.auth().currentUser!.email!]
        var opponentUID: String = ""
        
        DataHandeler.instance.GetInvites { (inv, success) in
            let opponentEmail = (inv[sender.tag] as! [String: String])["email"]
            let opponentVal: [String: Any] = ["email": opponentEmail!]
            DataHandeler.instance.GetUserSnapshot { (userSnapshot) in
                for user in userSnapshot {
                    let userDict = user.value as! [String: Any]
                    if userDict["email"] as! String == opponentEmail {
                        opponentUID = user.ref.key!
                    }
                }
                var a = DataHandeler.instance._REF_USERS_.child(opponentUID as! String).child("active_games")
                a.observeSingleEvent(of: .value) { (snapshot) in
                    if let snap = snapshot.value as? NSArray {
                        a.child(String(snap.count)).updateChildValues(val)
                        a.child(String(snap.count)).updateChildValues(["turn":0])
                        for i in 0...10 {
                            a.child(String(snap.count)).child("positions").updateChildValues([String(i): [5000,5000]])
                        }
                    } else {
                        a.child("0").updateChildValues(val)
                        a.child("0").updateChildValues(["turn":0])
                        for i in 0...10 {
                            a.child("0").child("positions").updateChildValues([String(i): [5000,5000]])
                        }
                    }
                }
                
                var b = DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.value(forKey: "uid") as! String).child("active_games")
                
                b.observeSingleEvent(of: .value) { (snapshot) in
                    if let snap = snapshot.value as? NSArray {
                        b.child(String(snap.count)).updateChildValues(opponentVal)
                        b.child(String(snap.count)).updateChildValues(["team":"circle"])
                        b.child(String(snap.count)).updateChildValues(["turn":0])
                        for i in 0...10 {
                            b.child(String(snap.count)).child("positions").updateChildValues([String(i): [5000,5000]])
                        }
                    } else {
                        b.child("0").updateChildValues(opponentVal)
                        b.child("0").updateChildValues(["team":"circle"])
                        b.child("0").updateChildValues(["turn":0])
                        for i in 0...10 {
                            b.child("0").child("positions").updateChildValues([String(i): [5000,5000]])
                        }
                    }
                    DataHandeler.instance.RemoveInvite(email: opponentEmail!, id: sender.tag)
                    self.tempArr.removeObject(at: sender.tag)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    @objc func DeclineInvite(sender: UIButton) {
        let dict = tempArr[sender.tag] as! [String: String]
        DataHandeler.instance.RemoveInvite(email: dict["email"]!, id: sender.tag)
        self.tempArr.removeObject(at: sender.tag)
        self.tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArr.count
    }
}
