//
//  LatestEventCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage
import SkeletonView

class LatestEventCell: UICollectionViewCell {

    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgaway: UIImageView!
    @IBOutlet weak var imghome: UIImageView!
    
    private let homeShadowView = UIView()
    private let awayShadowView = UIView()
    private var shadowLayerAdded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        
        self.layer.shadowColor = UIColor.appPrimary.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
        if !shadowLayerAdded {
            contentView.insertSubview(homeShadowView, belowSubview: imghome)
            contentView.insertSubview(awayShadowView, belowSubview: imgaway)
            shadowLayerAdded = true
        }
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        lblAway.isSkeletonable = true
        lblHome.isSkeletonable = true
        lblDate.isSkeletonable = true
        lblScore.isSkeletonable = true
        imgaway.isSkeletonable = true
        imghome.isSkeletonable = true
        
        lblAway.linesCornerRadius = 5
        lblHome.linesCornerRadius = 5
        lblDate.linesCornerRadius = 5
        lblScore.linesCornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let homeSize = min(imghome.bounds.width, imghome.bounds.height)
        let homeRadius = homeSize / 2
        imghome.layer.cornerRadius = homeRadius
        
        let awaySize = min(imgaway.bounds.width, imgaway.bounds.height)
        let awayRadius = awaySize / 2
        imgaway.layer.cornerRadius = awayRadius
        
        imghome.clipsToBounds = true
        imgaway.clipsToBounds = true
        imghome.contentMode = .scaleAspectFill
        imgaway.contentMode = .scaleAspectFill
        
        imghome.layer.borderWidth = 1.5
        imgaway.layer.borderWidth = 1.5
        imghome.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        imgaway.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        
        [homeShadowView, awayShadowView].forEach {
            $0.backgroundColor = .secondarySystemGroupedBackground
            $0.layer.masksToBounds = false
            $0.layer.shadowColor = UIColor.appPrimary.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 6
        }
        
        homeShadowView.frame = imghome.frame
        homeShadowView.layer.cornerRadius = homeRadius
        
        awayShadowView.frame = imgaway.frame
        awayShadowView.layer.cornerRadius = awayRadius
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        imghome.image = nil
        imgaway.image = nil
        lblHome.text = nil
        lblAway.text = nil
        lblDate.text = nil
        lblScore.text = nil
    }

    func setup(with event: Event) {
            lblHome.text = event.displayHomeName
            lblAway.text = event.displayAwayName
            lblDate.text = event.displayDate
            

            lblScore.text = event.displayResult
            
            if let homeLogoStr = event.displayHomeLogo, let homeUrl = URL(string: homeLogoStr) {
                imghome.sd_setImage(with: homeUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imghome.image = UIImage(named: "placeholder")
            }
            
            if let awayLogoStr = event.displayAwayLogo, let awayUrl = URL(string: awayLogoStr) {
                imgaway.sd_setImage(with: awayUrl, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imgaway.image = UIImage(named: "placeholder")
            }
        }
    
}
