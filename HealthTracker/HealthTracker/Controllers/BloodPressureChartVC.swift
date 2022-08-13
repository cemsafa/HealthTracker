//
//  BloodPressureChartVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-13.
//

import UIKit
import ObjectMapper
import Moya
import Charts

class BloodPressureChartVC: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    var sysDataEntries: [ChartDataEntry] = []
    var diaDataEntries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yAxis = chartView.leftAxis
        chartView.backgroundColor = UIColor(named: "AccentColor")
        chartView.rightAxis.enabled = false
        yAxis.labelFont = UIFont(name: "Montserrat-Bold", size: 13)!
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        chartView.xAxis.enabled = false

        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: sysDataEntries, label: "SYSTOLIC")
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(Helper.hexStringToUIColor(hex: "#FED173"))
        
        let set2 = LineChartDataSet(entries: diaDataEntries, label: "DIASTOLIC")
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3
        set2.setColor(Helper.hexStringToUIColor(hex: "#6572D1"))
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueFont(UIFont(name: "Montserrat-Bold", size: 13)!)
        data.setValueTextColor(.white)
        chartView.data = data
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getBloodPressuresSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let bloodPressures = Mapper<BloodPressuresSelf>().map(JSON: json as! [String: Any]), let bloodPressureData = bloodPressures.data {
                    var i = 0
                    for item in bloodPressureData {
                        self.sysDataEntries.append(ChartDataEntry(x: Double(i), y: Double(item.systolic ?? 0)))
                        self.diaDataEntries.append(ChartDataEntry(x: Double(i), y: Double(item.diastolic ?? 0)))
                        i += 1
                    }
                    self.setData()
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
