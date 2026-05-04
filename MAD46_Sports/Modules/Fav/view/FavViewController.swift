//
//  FavViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//

import UIKit

class FavViewController: UIViewController, FavView {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchFavorites()
    }
    
    func showFavorites() {
            tableView.isHidden = false
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            tableView.reloadData()
        }
        
        func showEmptyState() {
            tableView.isHidden = false
            
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            emptyLabel.text = "You haven't added any favorites yet! ⚽️"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            emptyLabel.numberOfLines = 0
            
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = .none
            tableView.reloadData()
        }
    
}

extension FavViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        guard let presenter = presenter else { return cell }
        
        let coreDataLeague = presenter.getLeague(at: indexPath.row)
        
        cell.labelTxt.text = coreDataLeague.leagueName
        
        if let logoData = coreDataLeague.leagueLogo {
            cell.imageV.image = UIImage(data: logoData)
        } else {
            cell.imageV.image = UIImage(named: "ball")
        }
        
        cell.updateFavIcon(isFav: true)
        
        cell.onFavTapped = { [weak self] in
            guard let self = self else { return }
            self.presenter?.removeFavorite(at: indexPath.row)
        }
        
        return cell
    }
}

extension FavViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
