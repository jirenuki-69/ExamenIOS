//
//  ProductView.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 11/06/22.
//

import UIKit

class ProductButton: UIButton {
    var id: String = ""
}


class ProductView: UITableViewCell {

    @IBOutlet weak var button: ProductButton!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
