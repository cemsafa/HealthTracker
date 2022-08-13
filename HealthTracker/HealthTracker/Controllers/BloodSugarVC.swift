//
//  BloodSugarVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-12.
//

import UIKit
import ObjectMapper
import Moya

class BloodSugarVC: UIViewController {

    @IBOutlet weak var glucoseLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var glucoseTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getBloodSugarsSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let bloodSugars = Mapper<BloodSugarSelf>().map(JSON: json as! [String: Any]) {
                    guard let bloodSugar = bloodSugars.data?.last else { return }
                    self.dateLbl.text = Helper.getLocalDate(from: bloodSugar.createdAt) ?? "N/A"
                    self.glucoseLbl.text = String(bloodSugar.glucose ?? 0)
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
        if glucoseTF.text != nil && glucoseTF.text != "" {
            let glucose = Int(glucoseTF.text!)
            APIManager.providerNoLog.request(.addBloodSugar(userId: userId, glucose: glucose!)) { result in
                switch result {
                case .success(let response):
                    if let json = try? response.mapJSON(), let bloodSugar = Mapper<BloodSugar>().map(JSON: json as! [String: Any]) {
                        self.dateLbl.text = Helper.getLocalDate(from: bloodSugar.createdAt) ?? "N/A"
                        self.glucoseLbl.text = String(bloodSugar.glucose ?? 0)
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
        let bloodSugarChartVC = storyboard.instantiateViewController(withIdentifier: "BloodSugarChartVC") as! BloodSugarChartVC
        self.navigationController?.pushViewController(bloodSugarChartVC, animated: true)
    }
}
