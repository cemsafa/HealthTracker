//
//  Alert.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import Foundation
import UIKit

class Alert {
    class func showAlertControllerWith(title: String? = nil, message: String?, onVC: UIViewController, style: UIAlertController.Style = .alert, buttons: [String], completion:((Bool, Int) -> Void)?) -> Void {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: style)
        for (index, title) in buttons.enumerated() {
            let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                completion?(true, index)
            }
            ac.addAction(action)
        }
        onVC.present(ac, animated: true, completion: nil)
    }
}
