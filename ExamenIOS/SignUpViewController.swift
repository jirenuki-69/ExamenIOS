//
//  SignUpViewController.swift
//  ExamenIOS
//
//  Created by Ingenieria on 16/05/22.
//

import UIKit
import Foundation
import Alamofire

struct ErrorMessage: Decodable {
    let message: String
}

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var btn: UIButton!
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
    
    func crearCarrito(idUsuario: String) {
        let parameters: [String: Any] = [
            "user": idUsuario
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito", method: .post, parameters: parameters, headers: HTTPHeaders.default)
        request.responseDecodable(of: [String: [String]].self) { response in
            print(response)
        }
    }
    
    func register(username: String, password: String) {
        
        let url = URL(string: "http://3.145.100.233:4000/api/usuario")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        
        let postString = "username=\(username)&password=\(password)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            if let error = error {
                self.alert(title: "Error", message: "Ha ocurrido un error, favor de intentar más tarde.")
                
                return
            }
            
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let data = Data(dataString.utf8)
                
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        if (json["message"] == nil) {
                            self.crearCarrito(idUsuario: (json["insertedIds"] as! [String])[0])
                            self.alert(title: "Usuario Creado", message: "El usuario ha sido registrado con éxito.")                        } else {
                                self.alert(title: "Error", message: json["message"] as! String)
                            }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                // self.alert(title: "Usuario Creado", message: "El usuario ha sido registrado con éxito.")
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
