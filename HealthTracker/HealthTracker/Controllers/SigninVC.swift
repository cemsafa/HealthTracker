//
//  SigninVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import UIKit
import ObjectMapper
import Moya

class SigninVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var lblToSignup: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SigninVC.tapFunction))
        lblToSignup.isUserInteractionEnabled = true
        lblToSignup.addGestureRecognizer(tap)
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        signupVC.modalTransitionStyle = .crossDissolve
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
    
    @IBAction func signinBtnTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        APIManager.providerNoLog.request(.login(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let authResponse = Mapper<AuthResponse>().map(JSON: json as! [String: Any]), let token = authResponse.token {
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    APIManager.providerNoLog.request(.getUser) { result in
                        switch result {
                        case .success(let response):
                            if let json = try? response.mapJSON(), let user = Mapper<User>().map(JSON: json as! [String: Any]) {
                                UserData.user = user
                                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                                let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                homeVC.modalTransitionStyle = .crossDissolve
                                homeVC.modalPresentationStyle = .fullScreen
                                self.present(homeVC, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            guard let response = error.response else { return }
                            if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                                Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                            }
                        }
                    }
                }
            case .failure(let error):
                guard let response = error.response else { return }
                if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                    Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                }
                
            }
        }
    }
}
