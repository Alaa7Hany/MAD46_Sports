import UIKit

class LeaguesViewController: UIViewController, LeaguesView {

    @IBOutlet weak var tableView: UITableView!
    var presenter: LeaguePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = presenter.sport.capitalized
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.fetchLeague()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
           
            tableView.reloadData()
        }
    
    func showLeagues() {
        tableView.reloadData()
    }
}


extension LeaguesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let league = presenter.getLeague(at: indexPath.row)

        let placeholderImage = UIImage(named: presenter.sport)

        cell.setup(league, placeholder: placeholderImage)

        let isFav = presenter.isFavorite(at: indexPath.row)
        cell.updateFavIcon(isFav: isFav)

        cell.onFavTapped = { [weak self] in
            guard let self = self else { return }
            
            let newState = self.presenter.toggleFavorite(at: indexPath.row)
            
            cell.updateFavIcon(isFav: newState)
        }

        return cell
    }
}
extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LeaguesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterLeagues(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}
