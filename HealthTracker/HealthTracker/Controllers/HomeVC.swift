//
//  HomeVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import UIKit
import ObjectMapper
import Moya

class HomeVC: UIViewController {

    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var bPressureView: UIView!
    @IBOutlet weak var bSugarView: UIView!
    @IBOutlet weak var fitnessView: UIView!
    
    @IBOutlet weak var hrContainerView: UIView!
    @IBOutlet weak var bpContainerView: UIView!
    @IBOutlet weak var bsContainerView: UIView!
    @IBOutlet weak var fContainerView: UIView!
    
    @IBOutlet weak var hrDateLbl: UILabel!
    @IBOutlet weak var hrLbl: UILabel!
    @IBOutlet weak var bpDateLbl: UILabel!
    @IBOutlet weak var sysLbl: UILabel!
    @IBOutlet weak var diaLbl: UILabel!
    @IBOutlet weak var bsDateLbl: UILabel!
    @IBOutlet weak var bsLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var hLbl: UILabel!
    @IBOutlet weak var wLbl: UILabel!
    @IBOutlet weak var staminaLbl: UILabel!
    @IBOutlet weak var strengthLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hrContainerView.layer.cornerRadius = 10
        bpContainerView.layer.cornerRadius = 10
        bsContainerView.layer.cornerRadius = 10
        fContainerView.layer.cornerRadius = 10
        
        let hrTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.hrTapFunction))
        heartRateView.isUserInteractionEnabled = true
        heartRateView.addGestureRecognizer(hrTap)
        let bpTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.bpTapFunction))
        bPressureView.isUserInteractionEnabled = true
        bPressureView.addGestureRecognizer(bpTap)
        let bsTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.bsTapFunction))
        bSugarView.isUserInteractionEnabled = true
        bSugarView.addGestureRecognizer(bsTap)
        let fTap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.fTapFunction))
        fitnessView.isUserInteractionEnabled = true
        fitnessView.addGestureRecognizer(fTap)
        
        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getUserSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let user = Mapper<User>().map(JSON: json as! [String: Any]) {
                    UserData.user = user
                    guard let heartRate = UserData.user?.heartrates, let bloodPressure = UserData.user?.bloodpressures, let bloodSugar = UserData.user?.bloodsugars, let fitness = UserData.user?.fitnesses else { return }
                    self.hrDateLbl.text = Helper.getLocalDate(from: heartRate.last?.createdAt) ?? "N/A"
                    self.hrLbl.text = String(heartRate.last?.bpm ?? 0)
                    self.bpDateLbl.text = Helper.getLocalDate(from: bloodPressure.last?.createdAt) ?? "N/A"
                    self.sysLbl.text = String(bloodPressure.last?.systolic ?? 0)
                    self.diaLbl.text = String(bloodPressure.last?.diastolic ?? 0)
                    self.bsDateLbl.text = Helper.getLocalDate(from: bloodSugar.last?.createdAt) ?? "N/A"
                    self.bsLbl.text = String(bloodSugar.last?.glucose ?? 0)
                    self.ageLbl.text = String(fitness.last?.age ?? 0)
                    self.hLbl.text = String(fitness.last?.heigth ?? 0)
                    self.wLbl.text = String(fitness.last?.weigth ?? 0)
                    self.staminaLbl.text = fitness.last?.stamina?.capitalized ?? "N/A"
                    self.strengthLbl.text = fitness.last?.strength?.capitalized ?? "N/A"
                }
            case .failure(let error):
                guard let response = error.response else { return }
                if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                    Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                }
            }
        }
    }
    
    @IBAction func hrTapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let heartRateVC = storyboard.instantiateViewController(withIdentifier: "HeartRateVC") as! HeartRateVC
        self.navigationController?.pushViewController(heartRateVC, animated: true)
    }
    
    @IBAction func bpTapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let bloodPressureVC = storyboard.instantiateViewController(withIdentifier: "BloodPressureVC") as! BloodPressureVC
        self.navigationController?.pushViewController(bloodPressureVC, animated: true)
    }
    
    @IBAction func bsTapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let bloodSugarVC = storyboard.instantiateViewController(withIdentifier: "BloodSugarVC") as! BloodSugarVC
        self.navigationController?.pushViewController(bloodSugarVC, animated: true)
    }
    
    @IBAction func fTapFunction(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let fitnessVC = storyboard.instantiateViewController(withIdentifier: "FitnessVC") as! FitnessVC
        self.navigationController?.pushViewController(fitnessVC, animated: true)
    }
}
