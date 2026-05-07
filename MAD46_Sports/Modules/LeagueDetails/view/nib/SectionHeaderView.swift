//
//  SectionHeaderView.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setup(title: String){
        lblTitle.text = title
        lblTitle.text = title
    }
}
