//
//  TeamTableHeaderView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit
import SkeletonView

class TeamTableHeaderView: UIView {

    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        teamLogoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        teamLogoImageView.layer.borderWidth = 1.0
        teamLogoImageView.layer.cornerRadius = 16
        teamLogoImageView.layer.masksToBounds = true
        teamLogoImageView.contentMode = .scaleAspectFill
        
        isSkeletonable = true
        teamLogoImageView.isSkeletonable = true
        teamLogoImageView.skeletonCornerRadius = 16
        teamNameLabel.isSkeletonable = true
        teamNameLabel.linesCornerRadius = 8
    }

    static func loadFromNib() -> TeamTableHeaderView {
        let nib = UINib(nibName: "TeamTableHeaderView", bundle: nil)
        return  nib.instantiate(withOwner: nil, options: nil)
            .first as! TeamTableHeaderView
        
    }
}
