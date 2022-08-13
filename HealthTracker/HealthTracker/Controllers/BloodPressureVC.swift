//
//  BloodPressureVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-12.
//

import UIKit
import ObjectMapper
import Moya

class BloodPressureVC: UIViewController {

    @IBOutlet weak var sysLbl: UILabel!
    @IBOutlet weak var diaLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var sysTF: UITextField!
    @IBOutlet weak var diaTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getBloodPressuresSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let bloodPressures = Mapper<BloodPressuresSelf>().map(JSON: json as! [String: Any]) {
                    guard let bloodPressure = bloodPressures.data?.last else { return }
                    self.dateLbl.text = Helper.getLocalDate(from: bloodPressure.createdAt) ?? "N/A"
                    self.sysLbl.text = String(bloodPressure.systolic ?? 0)
                    self.diaLbl.text = String(bloodPressure.diastolic ?? 0)
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
        if sysTF.text != nil && sysTF.text != "" && diaTF.text != nil && diaTF.text != "" {
            let sys = Int(sysTF.text!)
            let dia = Int(diaTF.text!)
            APIManager.providerNoLog.request(.addBloodPressure(userId: userId, systolic: sys!, diastolic: dia!)) { result in
                switch result {
                case .success(let response):
                    if let json = try? response.mapJSON(), let bloodPressure = Mapper<BloodPressure>().map(JSON: json as! [String: Any]) {
                        self.dateLbl.text = Helper.getLocalDate(from: bloodPressure.createdAt) ?? "N/A"
                        self.sysLbl.text = String(bloodPressure.systolic ?? 0)
                        self.diaLbl.text = String(bloodPressure.diastolic ?? 0)
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
    
    @IBAction func chartBtnTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let bloodPressureChartVC = storyboard.instantiateViewController(withIdentifier: "BloodPressureChartVC") as! BloodPressureChartVC
        self.navigationController?.pushViewController(bloodPressureChartVC, animated: true)
    }
}
