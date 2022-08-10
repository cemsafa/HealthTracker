//
//  UserData.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation

class UserData {
    private static var token: String?
    
    static func getToken() -> String? {
        if token == nil {
            token = UserDefaults.standard.object(forKey: "token") as? String
        }
        return token
    }
    
    static func saveToken(_ t: String) {
        token = t
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    static var isLogingOut:Bool = false
    static func logout() {
        token = nil
        isLogingOut = true
        self.deleteUserInfo()
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    private static var _user: User?
    static var user: User? {
        get {
            if _user != nil {
                return _user
            }
            else {
                _user = self.getUserInfo()
                return _user
            }
        }
        set {
            _user = newValue
            if let user = newValue {
                self.saveUserInfo(user)
            }
        }
    }
    
    private static func getUserInfo() -> User? {
        if let user = UserDefaults.standard.data(forKey: "user"),
            let userInfo = try? JSONDecoder().decode(User.self, from: user) {
            return userInfo
        }
        return nil
    }
    
    private static func saveUserInfo(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }

    private static func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: "user")
    }
}

