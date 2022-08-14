//
//  FamilyMemberVC.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-13.
//

import UIKit
import ObjectMapper
import Moya

class FamilyMemberVC: UIViewController {
    
    @IBOutlet weak var familyTableView: UITableView!
    
    var members = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyTableView.delegate = self
        familyTableView.dataSource = self
        
        fetchRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRefresh()
    }
    
    func fetchRefresh() {
        APIManager.providerNoLog.request(.getFamilyMembersSelf) { result in
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(), let familyMembers = Mapper<FamilyMemberSelf>().map(JSON: json as! [String: Any]), let familyMemberData = familyMembers.data {
                    for item in familyMemberData {
                        APIManager.providerNoLog.request(.getUser(id: item.memberId!)) { result in
                            switch result {
                            case .success(let response):
                                if let json = try? response.mapJSON(), let member = Mapper<User>().map(JSON: json as! [String: Any]) {
                                    if self.members.contains(where: { $0.id == member.id}) {
                                        self.familyTableView.reloadData()
                                    } else {
                                        self.members.append(member)
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
                    self.familyTableView.reloadData()
                }
            case .failure(let error):
                guard let response = error.response else { return }
                if let json = try? response.mapJSON(), let err = Mapper<ErrorResponse>().map(JSON: json as! [String: Any]) {
                    Alert.showAlertControllerWith(message: err.message, onVC: self, buttons: ["OK"], completion: nil)
                }
            }
        }
    }
    
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Family Member", message: "", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.placeholder = "Search by email"
            textField = field
        }
        let action = UIAlertAction(title: "Add member", style: .default) { (action) in
            if textField.text != nil && textField.text != "" {
                guard let email = textField.text, let user = UserData.user else { return }
                APIManager.providerNoLog.request(.searchUser(email: email)) { result in
                    switch result {
                    case .success(let response):
                        if let json = try? response.mapJSON(), let member = Mapper<SearchUserResponse>().map(JSON: json as! [String: Any]), let memberId = member.id {
                            APIManager.providerNoLog.request(.addFamilyMember(userId: user.id!, memberId: memberId)) { result in
                                switch result {
                                case .success(_):
                                    self.fetchRefresh()
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
            } else {
                Alert.showAlertControllerWith(message: "Please fill email", onVC: self, buttons: ["OK"], completion: nil)
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FamilyMemberVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.familyTableView.dequeueReusableCell(withIdentifier: "familyMemberCell")!
        cell.textLabel?.text = members[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Montserrat-Bold", size: 20)!
        cell.textLabel?.textColor = UIColor(named: "AccentColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
