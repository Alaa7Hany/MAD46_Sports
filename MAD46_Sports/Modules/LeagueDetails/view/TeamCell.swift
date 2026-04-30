//
//  TeamCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage

protocol LeagueDetailsViewProtocol: AnyObject {
    func displayData()
    func startLoading()
    func stopLoading()
}

class TeamCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.clipsToBounds = true
        imageV.layer.borderWidth = 1
        imageV.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        imageV.layer.cornerRadius = imageV.bounds.height / 2
    }
    
    func setup(with logoUrlString: String?) {
            if let logoStr = logoUrlString, let url = URL(string: logoStr) {
                imageV.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageV.image = UIImage(named: "placeholder")
            }
        }

}
