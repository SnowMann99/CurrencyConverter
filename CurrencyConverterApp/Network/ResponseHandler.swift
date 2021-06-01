//
//  ResponseHandler.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import Moya

extension Server {
    
    final class ResponseHandler {
        
        private let jsonDecoder = JSONDecoder()
        private let response: Result<Response, MoyaError>
        
        init(_ response: Result<Response, MoyaError>) {
            self.response = response
        }
        
        func handle<T: Decodable>(_ method: Server.Method, with promise: NetworkPromise<T>) {
            
            switch response {
                case .success(let response):
                    
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        if let object = try? self.jsonDecoder.decode(T.self, from: response.data) {
                            promise.finish(object)
                        } else {
                            let error = Server.Error(.unknown)
                            promise.finish(error)
                        }
                    } else {
                        let error = try? response.mapJSON()
                        print(error as Any)
                    }
                            
                case .failure:
                    let error = Server.Error(.connectionFailure)
                    promise.finish(error)
                    
            }
        }
    }
}

