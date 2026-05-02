//
//  UpcomingEventCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit
import SDWebImage

class UpcomingEventCell: UICollectionViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var imgHome: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
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
