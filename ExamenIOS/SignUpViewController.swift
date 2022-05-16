//
//  SignUpViewController.swift
//  ExamenIOS
//
//  Created by Ingenieria on 16/05/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var usernameErrorTxt: UILabel!
    @IBOutlet weak var passwordErrorTxt: UILabel!
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameErrorTxt.isHidden = true
        passwordErrorTxt.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUsernameChange(_ sender: Any) {
        username = usernameTf.text ?? ""
    }
    
    @IBAction func onPasswordChange(_ sender: Any) {
        password = passwordTf.text ?? ""
    }
    
    @IBAction func onButtonPressed(_ sender: Any) {
        usernameErrorTxt.isHidden = !username.isEmpty
        passwordErrorTxt.isHidden = !password.isEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
