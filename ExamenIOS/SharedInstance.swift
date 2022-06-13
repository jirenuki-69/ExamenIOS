//
//  SharedInstance.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/06/22.
//

import Foundation

class UserSingleton: NSObject {
    static let sharedInstance = UserSingleton()
    var username: String = ""
    var _id: String = ""
    
    private override init() {
        
    }
    
    func setUser(usuario: Usuario) {
        username = usuario.username
        _id = usuario._id
    }
}
