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
    func confirmDeletion(at index: Int) {
        let alert = UIAlertController(
            title: "Remove from Favorites",
            message: "Are you sure you want to remove this league from your favorites?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = self.tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    cell.alpha = 0
                }) { _ in
                   
                    self.presenter.removeFavorite(at: index)
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    self.tableView.endUpdates()
                    
                    
                    if self.presenter.getCount() == 0 {
                        self.showEmptyState()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
            self.confirmDeletion(at: indexPath.row)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.confirmDeletion(at: indexPath.row)
        }
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
