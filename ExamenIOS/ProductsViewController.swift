//
//  ProductsViewController.swift
//  ExamenIOS
//
//  Created by Ingenieria on 06/06/22.
//

import UIKit
import Alamofire

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryId: String = ""
    var productos = [Producto]()
    @IBOutlet weak var nombreCategoriaTxt: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tabla: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as! ProductView
        let producto: Producto = productos[indexPath.row]
        
        cell.nombre.text = producto.nombre
        cell.precio.text = "$\(producto.precio)"
        cell.button.id = producto._id
        cell.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        
        return cell
    }
    
    func loadProducts(completed: @escaping () -> ()) {
        let parameters: Parameters = [
             "q": ["categoria": categoryId]
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/producto", method: .get, parameters: parameters)
        request.responseDecodable(of: Array<Producto>.self) { response in
            guard let data = response.value else { return }
            print(data)
            self.productos = data
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            completed()
        }
    }
    
    func loadCategory() {
        let request = AF.request("http://3.145.100.233:4000/api/categoria/\(categoryId)")
        print(request)
        request.responseDecodable(of: Categoria.self) { response in
            guard let data = response.value else { return }
            print(data)
            self.nombreCategoriaTxt.text = data.nombre
            self.nombreCategoriaTxt.isHidden = false
        }
    }
    
    @objc func touchButton(sender: CategoryButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        controller.productId = sender.id
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        
        loadProducts {
            self.tabla.isHidden = false
            self.tabla.reloadData()
        }
        loadCategory()
        
        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(UINib(nibName: "ProductView", bundle: nil), forCellReuseIdentifier: "ProductViewCell")
        
        // Do any additional setup after loading the view.
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
