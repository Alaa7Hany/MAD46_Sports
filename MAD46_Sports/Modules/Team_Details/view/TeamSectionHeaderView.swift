//
//  TeamSectionHeaderView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 06/05/2026.
//

import UIKit

class TeamSectionHeaderView: UITableViewHeaderFooterView {


    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionLabel.textColor = .appText
        sectionLabel.font = .systemFont(ofSize: 20, weight: .bold)
        contentView.backgroundColor = .clear
    }
}
 
