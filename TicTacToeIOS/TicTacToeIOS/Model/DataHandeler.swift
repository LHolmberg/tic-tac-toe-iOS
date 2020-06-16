import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataHandeler {
    static let instance = DataHandeler()
    
    private var _REF_BASE = DB_BASE
    public var _REF_USERS_ = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS_
    }
    
    func CreateDBUser(uid: String, userData: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func GetUserSnapshot(completion: @escaping ([DataSnapshot]) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            completion(userSnapshot)
        }
    }
    
    func GetUsername(email: String, handler: @escaping (_ username: String) -> Void) {
        GetUserSnapshot { (userSnapshot) in
            for i in userSnapshot where (i.value as! [String: Any])["email"] as! String == email {
                handler(i.childSnapshot(forPath: "username").value as! String)
            }
        }
    }
    
    func GetActiveGames(handler: @escaping (NSArray, Bool) -> Void) {
        let a =  _REF_USERS_.child(Auth.auth().currentUser!.uid).child("active_games")
        var dataList: NSArray = NSArray()
        
        a.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount != 0 {
                dataList = snapshot.value as! NSArray
                handler(dataList, true)
            } else {
                handler(dataList, false)
            }
        }
    }
    
    func FindUser(username: String, handler: @escaping (_ value: DataSnapshot, _ success: Bool) -> Void) {
        GetUserSnapshot { (userSnapshot) in
            var foundUser = false
            for user in userSnapshot {
                let dict = user.value as! [String: Any]
                if dict["username"] as! String == username {
                    foundUser = true
                    handler(user, foundUser)
                }
            }
            if foundUser == false {
                handler(userSnapshot[0], foundUser)
            }
        }
    }
    
    func GetInvites(handler: @escaping (NSArray, Bool) -> Void) {
        let a =  _REF_USERS_.child(Auth.auth().currentUser!.uid).child("invites")
        var dataList: NSArray = NSArray()
        
       a.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount != 0 {
                dataList = snapshot.value as! NSArray
                handler(dataList, true)
            } else {
                handler(dataList, false)
            }
        }
    }
    
    func RemoveInvite(email: String, id: Int) {
        GetInvites { (invites, _) in
            let a = self._REF_USERS_.child(Auth.auth().currentUser!.uid).child("invites")
            a.observeSingleEvent(of: .value) { (snapshot) in
                let dict = invites as! [[String: String]]
                for i in 0...dict.count-1 {
                    if dict[i]["email"]! == email && id == i {
                        snapshot.ref.removeValue()
                    }
                }
                snapshot.ref.removeValue()
            }
        }
    }
    
    func PresentAlert(message: String, error: Bool) {
        let alert = UIAlertController(title: error == false ? "Success" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func SendInvite(username: String, completion: @escaping (_ result: Bool) -> Void) {
        FindUser(username: username) { (foundUser, success) in
            if success == true {
                let user = foundUser.value as! [String: Any]
                let val: [String: String] = ["email": Auth.auth().currentUser!.email!]
                self.GetInvites { (invites, _) in
                    // swiftlint:disable all
                    var position: Int = 0
                    if invites.count > 0 {
                        position = invites.count
                    }
                    let dict = invites as! [[String: String]]
                    var dupelicate: Bool = false
                    for i in dict {
                        if i["email"] == user["email"]! as? String {
                            dupelicate = true
                        }
                    }
                    if dupelicate == false {
                        self._REF_USERS_.child(foundUser.key).child("invites").child(String(position)).updateChildValues(val)
                        self.PresentAlert(message: "Successfully invited " + username, error: false)
                        completion(true)
                    } else {
                        self.PresentAlert(message: "An invite to this user is already pending", error: true)
                        completion(false)
                    }
                    // swiftlint:enable all
                }
            } else {
                self.PresentAlert(message: "Could not find " + username, error: true)
                completion(false)
            }
        }
    }
}
