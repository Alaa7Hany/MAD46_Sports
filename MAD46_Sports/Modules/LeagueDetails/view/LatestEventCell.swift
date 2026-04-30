//
//  LatestEventCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage

class LatestEventCell: UICollectionViewCell {

    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgaway: UIImageView!
    @IBOutlet weak var imghome: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.masksToBounds = true
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
