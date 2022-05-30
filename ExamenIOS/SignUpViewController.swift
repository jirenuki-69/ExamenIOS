//
//  SignUpViewController.swift
//  ExamenIOS
//
//  Created by Ingenieria on 16/05/22.
//

import UIKit
import Foundation
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var usernameErrorTxt: UILabel!
    @IBOutlet weak var passwordErrorTxt: UILabel!
    
    var username: String = ""
    var password: String = ""
    
    func register(username: String, password: String) {
        
        let url = URL(string: "http://3.145.100.233:4000/api/usuario")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        
        let postString = "username=\(username)&password=\(password)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response:\n \(dataString)")
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeViewController
                self.present(newViewController, animated:true, completion:nil)
                
            }
        }
        
        task.resume()
    }
    
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
        
        if (!username.isEmpty && !password.isEmpty) {
            register(username: username, password: password)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
