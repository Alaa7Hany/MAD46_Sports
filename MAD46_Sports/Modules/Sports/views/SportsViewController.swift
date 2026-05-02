import UIKit

protocol SportsViewProtocol: AnyObject {
    func displaySports()}


class SportsViewController: UIViewController {

    @IBOutlet weak var switchtheme: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: SportsPresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "SportCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "sportsCell")
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = .zero
            }
        
        presenter.viewDidLoad()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: Constants.Defaults.themeKey)
        switchtheme.isOn = isDarkMode
    }
}

extension SportsViewController: SportsViewProtocol {
    
    func displaySports() {
        DispatchQueue.main.async {
             self.collectionView.reloadData()
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
        print("navigate ")
        presenter.didSelectSport(at: indexPath.row)
        print("navigated ")

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
        let isDarkMode = sender.isOn
        
        UserDefaults.standard.set(isDarkMode, forKey: Constants.Defaults.themeKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
}
