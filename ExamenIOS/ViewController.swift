//
//  ViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/05/22.
//

import UIKit

struct Message: Decodable {
    let user: Usuario
    let accessToken: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameErrorTxt: UILabel!
    @IBOutlet weak var passwordErrorTxt: UILabel!
    var username: String = ""
    var password: String = ""
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func parseJSON(data: Data) -> Message? {
        
        var returnValue: Message?
        do {
            returnValue = try JSONDecoder().decode(Message.self, from: data)
        } catch {
            print("Error took place: \(error.localizedDescription).")
        }
        
        return returnValue
    }
    
    func navigateToHome() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        DispatchQueue.main.async() {
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    func login(username: String, password: String) {
        let url = URL(string: "http://3.145.100.233:4000/api/usuario/validate")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        
        let postString = "username=\(username)&password=\(password)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if error != nil {
                self.alert(title: "Error", message: "Ha ocurrido un error, favor de intentar más tarde.")
                
                return
            }
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let data = Data(dataString.utf8)
                
                do {
                    if let message = self.parseJSON(data: data) {
                        let userInstance = UserSingleton.sharedInstance
                        userInstance.setUser(usuario: message.user)
                        print("Id usuario: ", UserSingleton.sharedInstance._id)
                    }
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        if (json["accessToken"] != nil) {
                            self.navigateToHome()
                        } else {
                            self.alert(title: "Error", message: json["message"] as! String)
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
    
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
        usernameErrorTxt.isHidden = !username.isEmpty
        passwordErrorTxt.isHidden = !password.isEmpty
        
        if (!username.isEmpty && !password.isEmpty) {
            login(username: username, password: password)
        }
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
    }
}
