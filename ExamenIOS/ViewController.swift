//
//  ViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUsernameChange(_ sender: Any) {
        username = usernameTf.text ?? ""
    }
    
    @IBAction func onPasswordChange(_ sender: Any) {
        password = passwordTf.text ?? ""
    }

    @IBAction func onLoginButtonPressed(_ sender: Any) {
        print(username)
        print(password)
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
    }
}
