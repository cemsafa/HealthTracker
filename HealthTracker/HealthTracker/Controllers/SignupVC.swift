//
//  SignupVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import UIKit
import ObjectMapper
import Moya

class SignupVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var lblToSignin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupVC.tapFunction))
        lblToSignin.isUserInteractionEnabled = true
        lblToSignin.addGestureRecognizer(tap)
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let signinVC = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        signinVC.modalTransitionStyle = .crossDissolve
        signinVC.modalPresentationStyle = .fullScreen
        self.present(signinVC, animated: true, completion: nil)
    }
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        guard let name = nameTF.text, let email = emailTF.text, let password = passwordTF.text else { return }
        APIManager.providerNoLog.request(.signup(name: name, email: email, password: password)) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let authResponse = Mapper<AuthResponse>().map(JSON: json as! [String: Any]), let token = authResponse.token {
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    APIManager.providerNoLog.request(.getUserSelf) { result in
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
