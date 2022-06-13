//
//  ProductoCarritoView.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 12/06/22.
//

import UIKit

class ProductoCarritoButton: UIButton {
    var id: String = ""
}

class ProductoCarritoView: UITableViewCell {
    @IBOutlet weak var button: ProductoCarritoButton!
    @IBOutlet weak var nombreTxt: UILabel!
    @IBOutlet weak var precioTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
