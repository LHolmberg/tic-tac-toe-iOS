import Foundation
import Firebase
import FirebaseUI

class AccountHandeler {
    private var email: String
    private var password: String
    private var username: String
    
    init(email: String, password: String, username: String) {
        self.email = email
        self.password = password
        self.username = username
    }
    
    static let instance  = DataHandeler()
    
    func RegisterUser(userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            guard let authDataResult = authDataResult else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": authDataResult.user.providerID, "email": authDataResult.user.email, "username": self.username]
            DataHandeler.instance.CreateDBUser(uid: authDataResult.user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func LoginUser(loginComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            
            loginComplete(true, nil)
        }
    }
}
