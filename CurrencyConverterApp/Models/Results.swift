//
//  CurrencyModel.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import Foundation

struct Results: Codable {
    
    let results: [String: CurrencyModel]
}

struct CurrencyModel: Codable {
    
    let id: String
    let currencyName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case currencyName
    }
    
}
