//
//  UpcomingEventCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage
import SkeletonView

class UpcomingEventCell: UICollectionViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    
    private let homeShadowView = UIView()
    private let awayShadowView = UIView()
    private var shadowLayerAdded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        layer.cornerRadius = 12
        
        layer.shadowColor = UIColor.appPrimary.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "AppSurface") ?? .secondarySystemGroupedBackground
        
        if !shadowLayerAdded {
            contentView.insertSubview(homeShadowView, belowSubview: imgHome)
            contentView.insertSubview(awayShadowView, belowSubview: imgAway)
            shadowLayerAdded = true
        }
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        lblTime.isSkeletonable = true
        lblDate.isSkeletonable = true
        lblAway.isSkeletonable = true
        lblHome.isSkeletonable = true
        imgAway.isSkeletonable = true
        imgHome.isSkeletonable = true
        
        lblTime.linesCornerRadius = 5
        lblDate.linesCornerRadius = 5
        lblAway.linesCornerRadius = 5
        lblHome.linesCornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let homeSize = min(imgHome.bounds.width, imgHome.bounds.height)
        let homeRadius = homeSize / 2
        imgHome.layer.cornerRadius = homeRadius
        
        let awaySize = min(imgAway.bounds.width, imgAway.bounds.height)
        let awayRadius = awaySize / 2
        imgAway.layer.cornerRadius = awayRadius
        
        imgHome.clipsToBounds = true
        imgAway.clipsToBounds = true
        imgHome.contentMode = .scaleAspectFill
        imgAway.contentMode = .scaleAspectFill
        
        imgHome.layer.borderWidth = 1.5
        imgAway.layer.borderWidth = 1.5
        imgHome.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        imgAway.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        
        [homeShadowView, awayShadowView].forEach {
            $0.backgroundColor = .secondarySystemGroupedBackground
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.appPrimary.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 6
        }
        
        homeShadowView.frame = imgHome.frame
        homeShadowView.layer.cornerRadius = homeRadius
        
        awayShadowView.frame = imgAway.frame
        awayShadowView.layer.cornerRadius = awayRadius
        
        contentView.applySubtlePrimaryGradient(radius: 12)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        imgHome.image = nil
        imgAway.image = nil
        lblHome.text = nil
        lblAway.text = nil
        lblDate.text = nil
        lblTime.text = nil
    }

    func setup(with event: Event) {
            lblHome.text = event.displayHomeName
            lblAway.text = event.displayAwayName
            lblDate.text = event.displayDate
            lblTime.text = event.eventTime
            
            if let homeLogoStr = event.displayHomeLogo, let homeUrl = URL(string: homeLogoStr) {
                imgHome.sd_setImage(with: homeUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imgHome.image = UIImage(named: "placeholder")
            }
            if let awayLogoStr = event.displayAwayLogo, let awayUrl = URL(string: awayLogoStr) {
                imgAway.sd_setImage(with: awayUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imgAway.image = UIImage(named: "placeholder")
            }
        }
    
}
