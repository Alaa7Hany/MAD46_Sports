//
//  SportCollectionViewCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 29/04/2026.
//

import UIKit

class SportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCardStyling()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    func configureCell(name: String, image: String){
        lblName.text = name
        imageV.image = UIImage(named: image)
    }
    
    private func setupCardStyling() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
        
        imageV.layer.cornerRadius = 20
        imageV.clipsToBounds = true
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.6, 1.0]
        imageV.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleAnimation(isHighlighted)
        }
    }

    private func toggleAnimation(_ show: Bool) {
        let transform = show ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        let bgColor = show ? UIColor.systemGray6.withAlphaComponent(0.5) : .clear

        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.transform = transform
            self.contentView.backgroundColor = bgColor
        }
    }

}
