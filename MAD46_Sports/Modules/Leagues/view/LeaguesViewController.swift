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
    
    func showLeagues() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension LeaguesViewController: UITableViewDataSource {
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

extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

