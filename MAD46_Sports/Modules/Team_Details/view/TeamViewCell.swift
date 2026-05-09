//
//  TeamViewCell.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//

import UIKit
import SkeletonView

final class TeamViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var roleBadgeLabel: UILabel!
    
    private let avatarShadowView = UIView()
    private var shadowLayerAdded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        configureSkeletonable()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        numberLabel.layer.cornerRadius = numberLabel.bounds.height / 2
        
        let avatarRadius = avatarImageView.bounds.height / 2
        avatarImageView.layer.cornerRadius = avatarRadius
        
        avatarShadowView.frame = avatarImageView.frame
        avatarShadowView.layer.cornerRadius = avatarRadius
        
        cardView.applySubtlePrimaryGradient(radius: 16)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        avatarImageView.image = nil
        nameLabel.text = nil
        subtitleLabel.text = nil
        numberLabel.text = nil
        roleBadgeLabel.text = nil
    }

    private func configureAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .appSurface
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.appPrimary.cgColor
        cardView.layer.shadowOpacity = 0.12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        cardView.layer.borderWidth = 0

        // Avatar Shadow
        if !shadowLayerAdded {
            cardView.insertSubview(avatarShadowView, belowSubview: avatarImageView)
            shadowLayerAdded = true
        }
        avatarShadowView.backgroundColor = .appSurface
        avatarShadowView.layer.masksToBounds = false
        avatarShadowView.layer.shadowColor = UIColor.appPrimary.cgColor
        avatarShadowView.layer.shadowOpacity = 0.15
        avatarShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        avatarShadowView.layer.shadowRadius = 5

        numberLabel.backgroundColor = UIColor.appPrimary.withAlphaComponent(0.1)
        numberLabel.textColor = .appPrimary
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.clipsToBounds = true

        avatarImageView.backgroundColor = UIColor.appSecondaryText.withAlphaComponent(0.1)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        nameLabel.textColor = .appText
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)

        subtitleLabel.textColor = .appSecondaryText
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let alignment: NSTextAlignment = isRTL ? .right : .left
        nameLabel.textAlignment = alignment
        subtitleLabel.textAlignment = alignment

        roleBadgeLabel.textColor = .white
        roleBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        roleBadgeLabel.textAlignment = .center
        roleBadgeLabel.layer.cornerRadius = 8
        roleBadgeLabel.clipsToBounds = true
    }
    
    private func configureSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        cardView.isSkeletonable = true
        
     
        if let stackView = nameLabel.superview {
            stackView.isSkeletonable = true
        }
        
        numberLabel.isSkeletonable = true
        numberLabel.linesCornerRadius = 16
        
        avatarImageView.isSkeletonable = true
        avatarImageView.skeletonCornerRadius = 20
        
        nameLabel.numberOfLines = 1
        nameLabel.isSkeletonable = true
        nameLabel.linesCornerRadius = 5
        nameLabel.lastLineFillPercent = 70
        
        subtitleLabel.isSkeletonable = true
        subtitleLabel.linesCornerRadius = 5
        subtitleLabel.lastLineFillPercent = 50
        
        roleBadgeLabel.isSkeletonable = false
    }
}
