//
//  PedidoView.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 13/06/22.
//

import UIKit

class PedidoView: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
