//
//  NetworkHelper.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import Moya

final class NetworkHelper {
    
    static let instance = NetworkHelper()
    
    private let serverProvider: MoyaProvider<Server.Method> = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25
        
        let session = Session(configuration: configuration)
        return MoyaProvider<Server.Method>(session: session)
    } ()
    
    // MARK: - Life Cycle
    
    private init() {}

    // MARK: - Available Requests
    
    func getData() -> NetworkPromise<Results> {
        let method = Server.Method.getData
        return NetworkPromise(method)
    }
    
    func convertCurrencies(from: String, to: String) -> NetworkPromise<[String: Double]> {
        let method = Server.Method.convertCurrencies(convertFrom: from, convertTo: to)
        return NetworkPromise(method)
    }
    
    // MARK: - Public Functions
    
    func request<T: Decodable>(_ method: Server.Method, with promise: NetworkPromise<T>) -> Cancellable {
        return serverProvider.request(method) { response in
            let responseHandler = Server.ResponseHandler(response)
            responseHandler.handle(method, with: promise)
        }
    }
    
}

