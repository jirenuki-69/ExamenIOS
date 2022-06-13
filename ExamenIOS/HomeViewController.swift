//
//  HomeViewController.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 29/05/22.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var categorias = [Categoria]()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tabla: UITableView!
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath) as! CategoryView
        let categoria: Categoria = categorias[indexPath.row]
        
        cell.img.kf.setImage(with: URL(string: categoria.img))
        // cell.img.image = cell.img.image?.resizeImageTo(size: CGSize(width: 220.0, height: 140.0))
        
        cell.button.setTitle(categoria.nombre, for: .normal)
        cell.button.id = categoria._id
        cell.button.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
        
        return cell
    }
    
    func loadCategories(completed: @escaping () -> ()) {
        let request = AF.request("http://3.145.100.233:4000/api/categoria")
        request.responseDecodable(of: Array<Categoria>.self) { response in
            guard let data = response.value else { return }
            self.categorias = data
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            completed()
        }
    }
    
    @objc func touchButton(sender: CategoryButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "productsList") as! ProductsViewController
        controller.categoryId = sender.id
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        
        loadCategories {
            self.tabla.isHidden = false
            self.tabla.reloadData()
        }
        
        
        tabla.dataSource = self
        tabla.delegate = self
        tabla.register(UINib(nibName: "CategoryView", bundle: nil), forCellReuseIdentifier: "CategoryViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
