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
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .secondarySystemGroupedBackground
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.08
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
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
