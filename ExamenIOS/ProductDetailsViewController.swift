//
//  ProductDetailsViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/06/22.
//

import UIKit
import Alamofire
import Kingfisher

class ProductDetailsViewController: UIViewController {
    
    var cantidad: Int = 1
    var productId: String = ""
    var precio: Int = 0
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nombreTxt: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var cantidadTxt: UILabel!
    @IBOutlet weak var precioTxt: UILabel!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var indicator2: UIActivityIndicatorView!
    
    func loadProduct() {
        let request = AF.request("http://3.145.100.233:4000/api/producto/\(productId)")
        request.responseDecodable(of: Producto.self) { response in
            guard let producto = response.value else { return }
            self.nombreTxt.text = producto.nombre
            self.precioTxt.text = "$\(producto.precio)"
            self.img.kf.setImage(with: URL(string: producto.img))
            
            self.precio = producto.precio
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.container.isHidden = false
        }
    }
    
    func calculatePrice() {
        precioTxt.text = "$\(cantidad * precio)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        indicator2.isHidden = true
        indicator2.stopAnimating()
        indicator2.hidesWhenStopped = true
        loadProduct()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func agregarCarrito(_ sender: Any) {
        indicator2.isHidden = false
        indicator2.startAnimating()
        boton.isEnabled = false
        cargarCarritoUsuario()
    }
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func cargarCarritoUsuario() {
        let parameters = [
            "query": " { \"user\": \"\(UserSingleton.sharedInstance._id)\" } "
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito", method: .get, parameters: parameters)
        request.responseDecodable(of: [Carrito].self) { response in
            guard var carritoUsuario = response.value else { return }
            
            for _ in 1...Int(self.stepper.value) {
                carritoUsuario[0].products.append(self.productId)
            }
            
            self.actualizarCarrito(carrito: carritoUsuario[0])
        }
    }
    
    func actualizarCarrito(carrito: Carrito) {
        let parameters: [String: Any] = [
            "user": UserSingleton.sharedInstance._id,
            "products": carrito.products
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/carrito/\(carrito._id)", method: .put, parameters: parameters, encoding: JSONEncoding.default)
        request.responseDecodable(of: Carrito.self) {response in
            self.indicator2.stopAnimating()
            self.indicator2.hidesWhenStopped = true
            self.boton.isEnabled = true
            self.alert(title: "Carrito actualizado", message: "Producto agregado al carrito")
        }
    }
    
    @IBAction func onStepperChange(_ sender: Any) {
        cantidadTxt.text = String(Int(stepper.value))
        cantidad = Int(stepper.value)
        calculatePrice()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
