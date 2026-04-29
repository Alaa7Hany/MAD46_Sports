//
//  UICollectionViewCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini11 on 29/04/2026.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    
    
    @IBOutlet weak var labelText: UILabel!
    
    
    @IBOutlet weak var desc: UIView!
    
    func setup(_ page: OnBoardingModel) {
        imageV.image = page.image
        labelText.text = page.title
     
    }
}
