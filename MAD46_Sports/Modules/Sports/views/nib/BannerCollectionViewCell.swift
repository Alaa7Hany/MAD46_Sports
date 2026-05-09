//
//  BannerCollectionViewCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 09/05/2026.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }

}
