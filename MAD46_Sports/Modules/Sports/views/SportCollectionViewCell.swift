//
//  SportCollectionViewCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 29/04/2026.
//

import UIKit

class SportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        imageV.clipsToBounds = true
    }
    
    func configureCell(name: String, image: String){
        lblName.text = name
        imageV.image = UIImage(named: image)
    }

}
