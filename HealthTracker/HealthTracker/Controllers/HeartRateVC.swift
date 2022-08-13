//
//  HeartRateVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-12.
//

import UIKit
import ObjectMapper
import Moya

class HeartRateVC: UIViewController {

    @IBOutlet weak var heartRateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var heartRateTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getHeartRatesSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let heartRates = Mapper<HeartRateSelf>().map(JSON: json as! [String: Any]) {
                    guard let heartRate = heartRates.data?.last else { return }
                    self.dateLbl.text = Helper.getLocalDate(from: heartRate.createdAt) ?? "N/A"
                    self.heartRateLbl.text = String(heartRate.bpm ?? 0)
                }
            case .failure(let error):
                guard let response = error.response else { return }
                if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                    Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                }
            }
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let userId = UserData.user?.id else { return }
        if heartRateTF.text != nil && heartRateTF.text != "" {
            let bpm = Int(heartRateTF.text!)
            APIManager.providerNoLog.request(.addHeartRate(userId: userId, bpm: bpm!)) { result in
                switch result {
                case .success(let response):
                    if let json = try? response.mapJSON(), let heartRate = Mapper<HeartRate>().map(JSON: json as! [String: Any]) {
                        self.dateLbl.text = Helper.getLocalDate(from: heartRate.createdAt) ?? "N/A"
                        self.heartRateLbl.text = String(heartRate.bpm ?? 0)
                    }
                case .failure(let error):
                    guard let response = error.response else { return }
                    if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                        Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                    }
                }
            }
        } else {
            Alert.showAlertControllerWith(message: "Please fill all fields", onVC: self, buttons: ["OK"], completion: nil)
        }
    }
}
