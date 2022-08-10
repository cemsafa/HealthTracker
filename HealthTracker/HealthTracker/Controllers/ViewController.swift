//
//  ViewController.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-05.
//

import UIKit
import ObjectMapper
import Moya

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.providerNoLog.request(.login(email: "example@mail.com", password: "ASDqwe123.")) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let authResponse = Mapper<AuthResponse>().map(JSON: json as! [String: Any]), let token = authResponse.token {
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    APIManager.providerNoLog.request(.getUser) { result in
                        switch result {
                        case .success(let response):
                            if let json = try? response.mapJSON(), let user = Mapper<User>().map(JSON: json as! [String: Any]) {
                                UserData.user = user
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
}
