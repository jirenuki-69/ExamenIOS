//
//  HomeViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 29/05/22.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    var categorias: Array<Categoria> = []
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesSv: UIScrollView!
    
    func loadCategories() {
        let request = AF.request("http://3.145.100.233:4000/api/categoria")
        request.responseDecodable(of: Array<Categoria>.self) { response in
            guard let data = response.value else { return }
            self.categorias = data
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.changeScrollView(data: self.categorias)
        }
    }
    
    func changeScrollView(data: Array<Categoria>) {
        categoriesSv.isHidden = false
        // categoriesSv.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        loadCategories()
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
