//
//  Carrito.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/06/22.
//

import Foundation

struct Carrito: Decodable {
    let _id: String
    var user: String
    var products: [String]
}
