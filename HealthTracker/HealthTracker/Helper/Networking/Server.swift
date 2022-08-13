//
//  Server.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Moya

public enum Server {
    case login(email: String, password: String)
    case signup(name: String, email: String, password: String)
    case getUserSelf
    case getUser(id: String)
    case getUsers
    case addFamilyMember(userId: String, memberId: String)
    case addBloodSugar(userId: String, glucose: Int)
    case addBloodPressure(userId: String, systolic: Int, diastolic: Int)
    case addHeartRate(userId: String, bpm: Int)
    case addFitness(userId: String, age: Int, weigth: Double, heigth: Double, stamina: String, strength: String)
    case getBloodSugarsSelf
    case getBloodPressuresSelf
    case getHeartRatesSelf
    case getFitnessesSelf
    case getFamilyMembersSelf
    case searchUser(email: String)
}

extension Server: TargetType {
    public var sampleData: Data {
        return Data()
    }
    
    public var baseURL: URL {
        return URL(string: "http://localhost:3000/api")!
    }

    public var path: String {
        switch self {
        case .login:
            return "/auth"
        case .signup:
            return "/users"
        case .getUserSelf:
            return "/users/self/me"
        case .getUser(let id):
            return "/users/\(id)"
        case .getUsers:
            return "/users"
        case .addFamilyMember:
            return "/familymembers"
        case .addBloodSugar:
            return "/bloodsugars"
        case .addBloodPressure:
            return "/bloodpressures"
        case .addHeartRate:
            return "/heartrates"
        case .addFitness:
            return "/fitnesses"
        case .getBloodSugarsSelf:
            return "/bloodsugars/contains/self"
        case .getBloodPressuresSelf:
            return "/bloodpressures/contains/self"
        case .getHeartRatesSelf:
            return "/heartrates/contains/self"
        case .getFitnessesSelf:
            return "/fitnesses/contains/self"
        case .getFamilyMembersSelf:
            return "/familymembers/contains/self"
        case .searchUser:
            return "/users/search"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUserSelf, .getUser, .getUsers, .getBloodSugarsSelf, .getBloodPressuresSelf, .getHeartRatesSelf, .getFitnessesSelf, .getFamilyMembersSelf: return .get
        case .login, .signup, .addFamilyMember, .addBloodSugar, .addBloodPressure, .addHeartRate, .addFitness, .searchUser: return .post
        }
    }

    public var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: [
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default)
        case .signup(let name, let email, let password):
            return .requestParameters(parameters: [
                "name": name,
                "email": email,
                "password": password
            ], encoding: JSONEncoding.default)
        case .getUserSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getUser:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getUsers:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .addFamilyMember(let userId, let memberId):
            return .requestParameters(parameters: [
                "userId": userId,
                "memberId": memberId
            ], encoding: JSONEncoding.default)
        case .addBloodSugar(let userId, let glucose):
            return .requestParameters(parameters: [
                "userId": userId,
                "glucose": glucose
            ], encoding: JSONEncoding.default)
        case .addBloodPressure(let userId, let systolic, let diastolic):
            return .requestParameters(parameters: [
                "userId": userId,
                "systolic": systolic,
                "diastolic": diastolic
            ], encoding: JSONEncoding.default)
        case .addHeartRate(let userId, let bpm):
            return .requestParameters(parameters: [
                "userId": userId,
                "bpm": bpm
            ], encoding: JSONEncoding.default)
        case .addFitness(let userId, let age, let weigth, let heigth, let stamina, let strength):
            return .requestParameters(parameters: [
                "userId": userId,
                "age": age,
                "weigth": weigth,
                "heigth": heigth,
                "stamina": stamina,
                "strength": strength
            ], encoding: JSONEncoding.default)
        case .getBloodSugarsSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getBloodPressuresSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getHeartRatesSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getFitnessesSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getFamilyMembersSelf:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .searchUser(let email):
            return .requestParameters(parameters: [
                "email": email
            ], encoding: JSONEncoding.default)
        }
    }

    public var headers: [String: String]? {
        var headers = [
            "Content-type": "application/json"
        ]
        if self.isAuthenticatedCall(), let token = UserDefaults.standard.value(forKey: "token") as? String {
            headers["Authorization"] = "Bearer " + token
        }
        return headers
    }

    public var validationType: ValidationType {
        return .successCodes
    }
    
    func isAuthenticatedCall() -> Bool {
        switch self {
        case .login, .signup: return false
        case .getUserSelf, .getUser, .getUsers, .addFamilyMember, .addBloodSugar, .addBloodPressure, .addHeartRate, .addFitness, .getBloodSugarsSelf, .getBloodPressuresSelf, .getHeartRatesSelf, .getFitnessesSelf, .getFamilyMembersSelf, .searchUser: return true
        }
    }
    
}
