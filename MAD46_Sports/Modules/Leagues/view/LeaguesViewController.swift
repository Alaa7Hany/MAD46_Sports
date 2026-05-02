//
//  LeaguesViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 29/04/2026.
//

import UIKit

class LeaguesViewController: UIViewController,LeaguesView{

    @IBOutlet weak var tableView: UITableView!
    var presenter : LeaguePresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.dataSource =  self
        presenter.fetchLeague()
    }
    func showLeagues() {
        tableView.reloadData()
    }
    

}
extension LeaguesViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

               let league = presenter.getLeague(at: indexPath.row)
             cell.setup(league)
        

                       return cell
    }
    
    
}
