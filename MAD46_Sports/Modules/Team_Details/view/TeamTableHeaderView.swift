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
        backgroundColor = .clear
        
        teamLogoImageView.layer.borderColor = UIColor.appPrimary.withAlphaComponent(0.3).cgColor
        teamLogoImageView.layer.borderWidth = 2.0
        teamLogoImageView.layer.cornerRadius = 48
        teamLogoImageView.layer.masksToBounds = true
        teamLogoImageView.contentMode = .scaleAspectFill
        teamLogoImageView.backgroundColor = .appSurface
        
        teamNameLabel.textColor = .appText
        teamNameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        isSkeletonable = true
        teamLogoImageView.isSkeletonable = true
        teamLogoImageView.skeletonCornerRadius = 48
        teamNameLabel.isSkeletonable = true
        teamNameLabel.linesCornerRadius = 8
    }

    static func loadFromNib() -> TeamTableHeaderView {
        let nib = UINib(nibName: "TeamTableHeaderView", bundle: nil)
        return  nib.instantiate(withOwner: nil, options: nil)
            .first as! TeamTableHeaderView
        
    }
}
