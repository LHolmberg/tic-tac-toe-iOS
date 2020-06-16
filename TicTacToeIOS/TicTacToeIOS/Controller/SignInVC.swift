//
//  ViewController.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-11.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBAction func SignIn(_ sender: Any) {
        if !emailTxt.text!.isEmpty || !passwordTxt.text!.isEmpty {
            let accountHandeler = AccountHandeler(email: emailTxt.text!, password: passwordTxt.text!, username: "")
            accountHandeler.LoginUser(loginComplete: { (success, nil) in
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter a valid email or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
