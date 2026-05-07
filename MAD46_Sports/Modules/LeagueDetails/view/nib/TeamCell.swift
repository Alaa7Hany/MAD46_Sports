//
//  TeamCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage
import SkeletonView

protocol LeagueDetailsViewProtocol: AnyObject {
    func displayData()
    func startLoading()
    func stopLoading()
}

class TeamCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        contentView.layer.masksToBounds = true
        imageV.clipsToBounds = true
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        imageV.isSkeletonable = true
        imageV.skeletonCornerRadius = 35  
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        imageV.image = nil
    }
    
    func setup(with logoUrlString: String?) {
            if let logoStr = logoUrlString, let url = URL(string: logoStr) {
                imageV.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageV.image = UIImage(named: "placeholder")
            }
        }

}
