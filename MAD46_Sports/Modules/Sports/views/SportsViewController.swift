import UIKit

protocol SportsViewProtocol: AnyObject {
    func displaySports()
    func navigateToLeagues(for sportName: String)
}


class SportsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: SportsPresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SportsPresenter(view: self)
 
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "SportCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "sportsCell")
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = .zero
            }
        
        presenter.viewDidLoad()
    }
}

extension SportsViewController: SportsViewProtocol {
    
    func displaySports() {
        DispatchQueue.main.async {
             self.collectionView.reloadData()
        }
    }
    
    func navigateToLeagues(for sportName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        

        if let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController {
            

            self.navigationController?.pushViewController(leaguesVC, animated: true)
        }
    }
}

extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getSportsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportsCell", for: indexPath) as! SportCollectionViewCell
        
         let sport = presenter.getSport(at: indexPath.row)
         cell.lblName.text = sport.sportName
         cell.imageV.image = UIImage(named: sport.sportThumb ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectSport(at: indexPath.row)
    }
}


extension SportsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalPadding = padding * 3
        let availableWidth = collectionView.bounds.width - totalPadding
        let cellWidth = availableWidth / 2
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    @IBAction func themeToggled(_ sender: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                if sender.isOn {
                    self.view.window?.overrideUserInterfaceStyle = .dark
                } else {
                    self.view.window?.overrideUserInterfaceStyle = .light
                }
            }
    }
    
    @IBAction func languageToggled(_ sender: UISwitch) {

    }
    
    
    
    
}
