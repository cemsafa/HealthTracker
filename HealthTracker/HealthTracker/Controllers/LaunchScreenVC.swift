//
//  LaunchScreenVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import UIKit

class LaunchScreenVC: UIViewController {
    
    var isFinishedLaunch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFinishedLaunch {
            self.showAppViewController()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showAppViewController()
                self.isFinishedLaunch = true
            }
        }
    }
    
    @objc private func showAppViewController() {
        
        if UserData.getToken() != nil {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            homeVC.modalTransitionStyle = .crossDissolve
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            signupVC.modalTransitionStyle = .crossDissolve
            signupVC.modalPresentationStyle = .fullScreen
            self.present(signupVC, animated: true, completion: nil)
        }
    }
}
