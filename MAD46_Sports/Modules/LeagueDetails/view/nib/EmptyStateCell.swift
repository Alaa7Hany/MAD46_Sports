//
//  EmptyStateCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//

import UIKit
import Lottie

class EmptyStateCell: UICollectionViewCell {

    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var animationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLottie()
    }
    
    private func setupLottie() {
        animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        
        animationView.frame = animationContainerView.bounds
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animationContainerView.addSubview(animationView)
    }
    
    func setup(message: String, animationName: String) {
        messageLabel.text = message
        animationView.animation = LottieAnimation.named(animationName)
        animationView.play()
    }
}
