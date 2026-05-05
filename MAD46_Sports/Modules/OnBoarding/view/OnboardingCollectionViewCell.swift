import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var desc: UITextView!
    
    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = desc.bounds
    }
    
    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        if let gradient = gradientLayer {
            desc.layer.insertSublayer(gradient, at: 0)
        }
        
        desc.backgroundColor = .clear
        desc.textColor = .white     }
    
    func setup(_ page: OnBoardingModel) {
        imageV.image = UIImage(named: page.image)
        desc.text = page.desc
    }
}
