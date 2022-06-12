//
//  CategoryView.swift
//  ExamenIOS
//
//  Created by Miguel Fuentes on 11/06/22.
//

import UIKit

class CategoryButton: UIButton {
    var id: String = ""
}

class CategoryView: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var button: CategoryButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
