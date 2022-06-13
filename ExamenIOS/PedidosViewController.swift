//
//  PedidosViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 13/06/22.
//

import UIKit
import Alamofire

class PedidosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pedidos = [Pedido]()

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTxt: UILabel!
    @IBOutlet weak var tabla: UITableView!
    
    @IBAction func onReload(_ sender: Any) {
        cargarPedidos()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PedidoViewCell", for: indexPath) as! PedidoView
        let pedido: Pedido = pedidos[indexPath.row]
        
        cell.nombre.text = "Pedido " + String(indexPath.row + 1)
        cell.id.text = pedido._id
        cell.status.text = pedido.status
        
        return cell
    }
    
    func cargarPedidos() {
        self.indicator.startAnimating()
        self.indicator.hidesWhenStopped = false
        let parameters = [
            "query": "{ \"user\": \"\(UserSingleton.sharedInstance._id)\" }"
        ]
        
        let request = AF.request("http://3.145.100.233:4000/api/pedido", method: .get, parameters: parameters)
        request.responseDecodable(of: [Pedido].self) { response in
            guard let data = response.value else { return }
            if (!data.isEmpty) {
                print(data)
                self.pedidos = data
                self.tabla.isHidden = false
                self.tabla.reloadData()
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.mainTxt.isHidden = true
            } else {
                self.mainTxt.isHidden = false
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarPedidos()
        
        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(UINib(nibName: "PedidoView", bundle: nil), forCellReuseIdentifier: "PedidoViewCell")
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
