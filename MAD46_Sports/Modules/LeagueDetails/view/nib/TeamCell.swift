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
    private let imageShadowView = UIView()
    private var shadowLayerAdded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor(named: "AppSurface") ?? .systemBackground
        contentView.layer.masksToBounds = false
        
        if let superView = imageV.superview, !shadowLayerAdded {
            superView.insertSubview(imageShadowView, belowSubview: imageV)
            shadowLayerAdded = true
        }
        
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        imageV.isSkeletonable = true
        imageV.skeletonCornerRadius = 42.5  
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        let size = min(imageV.bounds.width, imageV.bounds.height)
        let radius = size / 2
        
        imageV.layer.cornerRadius = radius
        imageV.layer.borderWidth = 1.5
        imageV.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        
        imageShadowView.frame = imageV.frame
        imageShadowView.backgroundColor = UIColor(named: "AppSurface") ?? .systemBackground
        imageShadowView.layer.cornerRadius = radius
        imageShadowView.layer.masksToBounds = false
        
        imageShadowView.layer.shadowColor = UIColor.appPrimary.cgColor
        imageShadowView.layer.shadowOpacity = 0.2
        imageShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageShadowView.layer.shadowRadius = 5
        
        contentView.layer.cornerRadius = 12 
        contentView.clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        
        imageShadowView.layer.shadowColor = UIColor.appPrimary.cgColor
        imageV.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        imageShadowView.backgroundColor = UIColor(named: "AppSurface") ?? .systemBackground
        contentView.backgroundColor = UIColor(named: "AppSurface") ?? .systemBackground
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
