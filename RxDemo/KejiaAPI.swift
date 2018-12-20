//
//  KejiaAPI.swift
//  RxDemo
//
//  Created by 老王 on 2018/12/19.
//  Copyright © 2018 老王. All rights reserved.
//

import UIKit
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let locationProvider = MoyaProvider<LocationAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum LocationAPI {
    case location(Dictionary<String, String>)
}

extension LocationAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://apis.map.qq.com/ws/geocoder/v1")! }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .location(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        switch self {
            default:
                return .none
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .location:
            return "ABCDEFG".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        return nil
    }
    
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
