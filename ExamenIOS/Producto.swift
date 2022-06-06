//
//  Producto.swift
//  ExamenIOS
//
//  Created by Ingenieria on 06/06/22.
//

import Foundation

struct Producto: Decodable {
    let _id: String
    let nombre: String
    let precio: Int
    let categoria: String
    let img: String
}
