//
//  SportsViewController+UI.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 08/05/2026.
//
import UIKit

// MARK: - UI Setup
extension SportsViewController {
    
    func setupInitialUI() {
        let isDarkMode = UserDefaults.standard.bool(forKey: Constants.Defaults.themeKey)
        let themeIcon = isDarkMode ? Constants.Icons.darkMode : Constants.Icons.lightMode
        btnTheme.setImage(UIImage(systemName: themeIcon), for: .normal)
        let isSoundMuted = UserDefaults.standard.bool(forKey: Constants.Defaults.soundKey)
        let soundIcon = isSoundMuted ? Constants.Icons.soundOff: Constants.Icons.soundOn
        btnSound.setImage(UIImage(systemName: soundIcon), for: .normal)
    }
}

// MARK: - Actions
extension SportsViewController {
    
    @IBAction func onThemechanged(_ sender: UIButton) {
        SoundManager.shared.playSound(Constants.Sounds.click)

        let isCurrentlyDark = UserDefaults.standard.bool(forKey: Constants.Defaults.themeKey)
        let newDarkModeState = !isCurrentlyDark
        
        UserDefaults.standard.set(newDarkModeState, forKey: Constants.Defaults.themeKey)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = newDarkModeState ? .dark : .light
        }
        
        let iconName = newDarkModeState ? Constants.Icons.darkMode : Constants.Icons.lightMode
        btnTheme.setImage(UIImage(systemName: iconName), for: .normal)
        
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
    }
    
    @IBAction func onSoundChanged(_ sender: UIButton) {
        let isCurrentlyMuted = UserDefaults.standard.bool(forKey: Constants.Defaults.soundKey)
        let newMutedState = !isCurrentlyMuted
        
        UserDefaults.standard.set(newMutedState, forKey: Constants.Defaults.soundKey)
        
        if !newMutedState {
            SoundManager.shared.playSound(Constants.Sounds.click)
        }
        
        let iconName = newMutedState ? Constants.Icons.soundOff : Constants.Icons.soundOn
        btnSound.setImage(UIImage(systemName: iconName), for: .normal)
        
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
    }
}

// MARK: - Easter Egg Trigger
extension SportsViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            let gameVC = BasketballGameViewController()
            gameVC.modalPresentationStyle = .overFullScreen
            gameVC.modalTransitionStyle = .crossDissolve
            self.present(gameVC, animated: true, completion: nil)
        }
    }
}
