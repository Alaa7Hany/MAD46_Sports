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
    

    @IBOutlet weak var favBtn: UIButton!
    
    @IBAction func onFav(_ sender: Any) {
        
        onFavTapped?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageV.layer.cornerRadius = imageV.frame.height / 2
        imageV.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setup(_ league: LeagueModel, placeholder: UIImage?) {
        labelTxt.text = league.leagueName

        if let urlString = league.leagueLogo,
           let url = URL(string: urlString) {
           
            imageV.sd_setImage(with: url, placeholderImage: placeholder)

        } else {
            imageV.image = placeholder
        }
    }
    func updateFavIcon(isFav : Bool)
    {
        let image = isFav ? "heart.fill" : "heart"
            favBtn.setImage(UIImage(systemName: image), for: .normal)
            favBtn.tintColor = .red
    }
}

