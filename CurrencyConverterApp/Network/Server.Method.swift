//
//  Server.Method.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import Moya

extension Server {
    
    enum Method: TargetType {
        
        case getData
        case convertCurrencies(convertFrom: String, convertTo: String)
        
        // MARK: - Configurations
        
        var baseURL: URL {
            return Server.getBaseURL()
        }
        
        var path: String {
            var target: String
            
            switch self {
                case .getData:
                    target = "/api/v7/currencies"
                    
                case .convertCurrencies:
                    target = "/api/v7/convert"
            }
            return "\(target)"
        }
        
        var task: Task {
            
            let apiKey = ["apiKey":"7a94a966d01f11022152"]
            var convertParams = ""
            
            switch self {
                case .getData:
                    
                    return Task.requestParameters(parameters: apiKey, encoding: URLEncoding.queryString)
                    
                case let .convertCurrencies(convertFrom, convertTo):
                    convertParams = "\(convertFrom)_\(convertTo)"
                    
                    return Task.requestParameters(parameters: ["q": convertParams, "apiKey": "7a94a966d01f11022152", "compact": "ultra"], encoding: URLEncoding.queryString)
            }
        }
        
        var method: Moya.Method {
            switch self {
                case .getData:
                    return .get
                case .convertCurrencies:
                    return .get
            }
        }
    
        var headers: [String: String]? { .none }
    
        var sampleData: Data {
            return Data()
        }
    }
}
