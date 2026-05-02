import UIKit

class LeaguesViewController: UIViewController, LeaguesView {

    @IBOutlet weak var tableView: UITableView!
    var presenter: LeaguePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title dynamically based on the selected sport
        self.title = presenter.sport.capitalized
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self // 👉 ADD THIS
        
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

// 👉 ADD THIS EXTENSION: UITableViewDelegate
extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove the gray highlight after click
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Tell the presenter which row was clicked
        presenter.didSelectLeague(at: indexPath.row)
    }
}
