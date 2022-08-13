//
//  FitnessVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-12.
//

import UIKit
import ObjectMapper
import Moya

class FitnessVC: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var hLbl: UILabel!
    @IBOutlet weak var wLbl: UILabel!
    @IBOutlet weak var staminaLbl: UILabel!
    @IBOutlet weak var strengthLbl: UILabel!
    
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var weigthTF: UITextField!
    @IBOutlet weak var heigthTF: UITextField!
    
    @IBOutlet weak var staminaPicker: UIPickerView!
    @IBOutlet weak var strengthPicker: UIPickerView!
    
    let pickerData = ["High", "Medium", "Low"]
    var selectedStamina: String!
    var selectedStrength: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staminaPicker.delegate = self
        staminaPicker.dataSource = self
        strengthPicker.delegate = self
        strengthPicker.dataSource = self

        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getFitnessesSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let fitnesses = Mapper<FitnessSelf>().map(JSON: json as! [String: Any]) {
                    guard let fitness = fitnesses.data?.last else { return }
                    self.dateLbl.text = Helper.getLocalDate(from: fitness.createdAt) ?? "N/A"
                    self.ageLbl.text = String(fitness.age ?? 0)
                    self.hLbl.text = String(fitness.heigth ?? 0)
                    self.wLbl.text = String(fitness.weigth ?? 0)
                    self.staminaLbl.text = fitness.stamina?.capitalized ?? "N/A"
                    self.strengthLbl.text = fitness.strength?.capitalized ?? "N/A"
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
        if ageTF.text != nil && ageTF.text != "" && heigthTF.text != nil && heigthTF.text != "" && weigthTF.text != nil && weigthTF.text != "" && selectedStamina != nil && selectedStrength != nil {
            let age = Int(ageTF.text!)
            let heigth = Double(heigthTF.text!)
            let weigth = Double(weigthTF.text!)
            let stamina = selectedStamina
            let strength = selectedStrength
            APIManager.providerNoLog.request(.addFitness(userId: userId, age: age!, weigth: weigth!, heigth: heigth!, stamina: stamina!.lowercased(), strength: strength!.lowercased())) { result in
                switch result {
                case .success(let response):
                    if let json = try? response.mapJSON(), let fitness = Mapper<Fitness>().map(JSON: json as! [String: Any]) {
                        self.dateLbl.text = Helper.getLocalDate(from: fitness.createdAt) ?? "N/A"
                        self.ageLbl.text = String(fitness.age ?? 0)
                        self.hLbl.text = String(fitness.heigth ?? 0)
                        self.wLbl.text = String(fitness.weigth ?? 0)
                        self.staminaLbl.text = fitness.stamina?.capitalized ?? "N/A"
                        self.strengthLbl.text = fitness.strength?.capitalized ?? "N/A"
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension FitnessVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == staminaPicker {
            selectedStamina = pickerData[row]
        }
        if pickerView == strengthPicker {
            selectedStrength = pickerData[row]
        }
    }
}
