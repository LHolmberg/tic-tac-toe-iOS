import UIKit
import FirebaseUI
import SpriteKit

class Home: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tempArr: NSMutableArray = []
    var refreshControl = UIRefreshControl()
    
    func Initialize() {
        if let user = Auth.auth().currentUser {
            DataHandeler.instance._REF_USERS_.child(user.value(forKey: "uid") as!
                        String).child("active_games").observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? NSArray {
                    self.tempArr = snap as! NSMutableArray
                    self.tableView.reloadData()
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                }
            }
        }
    }
    
    @IBAction func SignOutBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "toLoginScreen", sender: nil)
            } catch {
                print("Error signing out")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        Initialize()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Initialize()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Initialize()
    }
    
    @IBAction func InvitesBtn(_ sender: Any) {
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InvitesVC") as! InvitesVC
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
    }
    
    @IBAction func NewGameBtn(_ sender: Any) {
        let popover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchUserVC") as! SearchUserVC
        self.addChild(popover)
        popover.view.frame = self.view.frame
        self.view.addSubview(popover.view)
        popover.didMove(toParent: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gameView", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gameView") {
            if let vc: TicTacToeVC = segue.destination as? TicTacToeVC {
                vc.id = sender as! Int
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveGameTVCell", for: indexPath as IndexPath) as! ActiveGameTVCell
        var opponentEmail: String = ""
        let opponentDict = tempArr[indexPath.row] as! [String: Any]
        
        opponentEmail = opponentDict["email"] as! String
        DataHandeler.instance.GetUsername(email: opponentEmail) { (username) in
            cell.opponentTxt.text = username
        }
        
        DataHandeler.instance._REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games").child(String(indexPath.row)).observeSingleEvent(of: .value) { (snapshot) in
            if let t = snapshot.value as? [String: Any] {
                if t["team"] != nil {
                    if t["turn"] as! Int % 2 == 0 {
                        DispatchQueue.main.async {
                            cell.whosTurnTxt.text = "Your turn!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.whosTurnTxt.text = "Opponents turn"
                        }
                    }
                } else {
                    if t["turn"] as! Int % 2 == 0 {
                        DispatchQueue.main.async {
                            cell.whosTurnTxt.text = "Opponents turn"
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.whosTurnTxt.text = "Your turn!"
                        }
                    }
                }
            } else {
                self.tempArr.removeAllObjects()
                self.Initialize()
                self.tableView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArr.count
    }
}
