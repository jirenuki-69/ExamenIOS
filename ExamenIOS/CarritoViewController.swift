//
//  CarritoViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/06/22.
//

import UIKit
import Alamofire

class CarritoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var productos = [Producto]()
    var carritoId = ""
    
    @IBOutlet weak var enviarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var totalTxt: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCarritoViewCell", for: indexPath) as! ProductoCarritoView
        let producto: Producto = productos[indexPath.row]
        
        cell.nombreTxt.text = producto.nombre
        cell.precioTxt.text = "$\(producto.precio)"
        cell.button.id = producto._id
        cell.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        
        return cell
    }
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    @IBAction func onReload(_ sender: Any) {
        loadUserCart()
    }
    
    @objc func touchButton(sender: CategoryButton) {
        let parameters = [
            "query": "{ \"user\": \"\(UserSingleton.sharedInstance._id)\" }"
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito", method: .get, parameters: parameters)
        request.responseDecodable(of: [Carrito].self) { response in
            guard var carrito = response.value else { return }
            let productoIndex = carrito[0].products.firstIndex(where: { value -> Bool in
                value == sender.id
            })
            self.productos.remove(at: productoIndex!)
            carrito[0].products.remove(at: productoIndex!)

            let parameters2: [String: Any] = [
                "user": UserSingleton.sharedInstance._id,
                "products": carrito[0].products
            ]
            
            let request = AF.request("http://3.145.100.233:4000/api/carrito/\(carrito[0]._id)", method: .put, parameters: parameters2, encoding: JSONEncoding.default)
            request.responseDecodable(of: Carrito.self) {response in
                self.alert(title: "Borrado", message: "Producto borrado del carrito")
                self.tabla.reloadData()
                self.calcularPrecio(productos: self.productos)
            }
        }
    }
    
    func calcularPrecio(productos: [Producto]) {
        var suma = 0
        
        for producto in productos {
            suma = suma + producto.precio
        }
        
        self.totalTxt.text = "$\(suma)"
    }
    
    func getObjectIdQuery(array: [String]) -> String {
        var string = ""
        for i in 0...(array.count - 1) {
            let productoId = array[i]
            if (i == array.count - 1) {
                string = string + "\"ObjectId('\(productoId)')\""
                break
            }
            
            string = string + "\"ObjectId('\(productoId)')\", "
        }
        
        return string
    }
    
    func getProducts(carrito: Carrito, completed: @escaping () -> ()) {
        if (!carrito.products.isEmpty) {
            let query = self.getObjectIdQuery(array: carrito.products)
            let parameters = [
                "query": " { \"_id\": { \"$in\": [\(query)] } } "
            ]
            
            let request = AF.request("http://3.145.100.233:4000/api/producto", method: .get, parameters: parameters)
            request.responseDecodable(of: [Producto].self) { response in
                guard let data = response.value else { return }
                var productosTemp = [Producto]()
                for productoId in carrito.products {
                    let producto = data.first(where: { value -> Bool in
                        value._id == productoId
                    })
                    productosTemp.append(producto!)
                }
                self.productos = productosTemp
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                completed()
            }
        } else {
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }
    
    func loadUserCart() {
        let parameters = [
            "query": "{ \"user\": \"\(UserSingleton.sharedInstance._id)\" }"
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito", method: .get, parameters: parameters)
        request.responseDecodable(of: [Carrito].self) { response in
            guard let data = response.value else { return }
            if (!data.isEmpty) {
                self.carritoId = data.first!._id
                self.getProducts(carrito: data.first!) {
                    self.tabla.isHidden = false
                    self.tabla.reloadData()
                    self.totalTxt.isHidden = false
                    self.calcularPrecio(productos: self.productos)
                }
            }
        }
    }
    
    @IBAction func enviar(_ sender: Any) {
        if (productos.isEmpty) {
            self.alert(title: "Alerta", message: "No tiene productos en su carrito")
            
            return
        }
        
        let temp = productos.map { $0._id }
        
        let parameters: [String: Any] = [
            "user": UserSingleton.sharedInstance._id,
            "products": temp,
            "status": "En curso"
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/pedido", method: .post, parameters: parameters)
        request.responseDecodable(of: [String: [String]].self) { response in
            self.alert(title: "Pedido creado", message: "Su pedido ha sido creado")
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        if (productos.isEmpty) {
            self.alert(title: "Alerta", message: "No tiene productos en su carrito")
            
            return
        }
        
        let parameters: [String: Any] = [
            "user": UserSingleton.sharedInstance._id,
            "products": []
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito/\(self.carritoId)", method: .put, parameters: parameters, encoding: JSONEncoding.default)
        request.responseDecodable(of: Carrito.self) {response in
            self.alert(title: "Carrito vacío", message: "Productos borrados del carrito")
            self.productos = [Producto]()
            self.tabla.reloadData()
            self.totalTxt.text = "Sin Productos"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        loadUserCart()
        
        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(UINib(nibName: "ProductoCarritoView", bundle: nil), forCellReuseIdentifier: "ProductoCarritoViewCell")
    }

}

extension String {
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}
