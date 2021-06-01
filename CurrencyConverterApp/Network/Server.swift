//
//  Server.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import Foundation

final class Server {
    
    // MARK: - Life Cycle
    
    private init() { }
    
    // MARK: - Static Functions
    
    static func getBaseURL() -> URL {
        return URL(string: "https://free.currconv.com")!
    }
    
}
