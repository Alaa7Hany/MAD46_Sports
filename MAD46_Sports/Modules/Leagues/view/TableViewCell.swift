//
//  TableViewCell.swift
//  MAD46_Sports
//
//  Created by TaqieAllah on 30/04/2026.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var labelTxt: UILabel!
    var onFavTapped: (() -> Void)?
    

    @IBAction func onFav(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageV.layer.cornerRadius = imageV.frame.width / 2
        imageV.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setup(_ league: LeagueModel) {
        labelTxt.text = league.leagueName

        if let urlString = league.leagueLogo,
           let url = URL(string: urlString) {

            imageV.sd_setImage(with: url, placeholderImage: UIImage(named: "ball"))

        } else {
            imageV.image = UIImage(named: "ball")
        }
    }
}
