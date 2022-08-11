//
//  ProfileVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-11.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.text = UserData.user?.name
        emailTF.text = UserData.user?.email
    }
    
    @IBAction func signoutBtnTapped(_ sender: Any) {
        UserData.logout()
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        signupVC.modalTransitionStyle = .crossDissolve
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
}
