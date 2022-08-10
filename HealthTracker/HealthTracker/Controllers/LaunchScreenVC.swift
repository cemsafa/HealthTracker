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
//            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//            let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//            tabBarViewController.modalTransitionStyle = .crossDissolve
//            tabBarViewController.modalPresentationStyle = .fullScreen
//            self.present(tabBarViewController, animated: true, completion: nil)
        } else {
//            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//            let onBoardingVC = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingVC
//            onBoardingVC.modalTransitionStyle = .crossDissolve
//            onBoardingVC.modalPresentationStyle = .fullScreen
//            self.present(onBoardingVC, animated: true, completion: nil)
        }
    }
}
