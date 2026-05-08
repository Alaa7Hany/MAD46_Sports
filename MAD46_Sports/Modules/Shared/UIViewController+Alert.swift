//
//  UIViewController+Alert.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 08/05/2026.
//

import UIKit

extension UIViewController {
    func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
