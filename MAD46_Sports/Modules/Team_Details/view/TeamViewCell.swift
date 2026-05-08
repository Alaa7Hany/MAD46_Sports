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

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        configureSkeletonable()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        numberLabel.layer.cornerRadius = numberLabel.bounds.height / 2
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
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

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor(red: 0.08, green: 0.10, blue: 0.30, alpha: 1).cgColor
        cardView.layer.shadowOpacity = 0.10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
           cardView.layer.borderWidth = 0

        numberLabel.backgroundColor = UIColor(red: 0.93, green: 0.95, blue: 0.98, alpha: 1)
        numberLabel.textColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 1)
        numberLabel.font = .systemFont(ofSize: 16, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.clipsToBounds = true

        avatarImageView.backgroundColor = UIColor(red: 0.93, green: 0.95, blue: 0.98, alpha: 1)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        nameLabel.textColor = UIColor(red: 0.07, green: 0.09, blue: 0.20, alpha: 1)
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)

        subtitleLabel.textColor = .secondaryLabel
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
