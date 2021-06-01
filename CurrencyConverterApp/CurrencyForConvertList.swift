//
//  CurrencyForConvertList.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 27.05.2021.
//


final class CurrenciesToConvert {
    
    //MARK: - Properties
    
    static let shared = CurrenciesToConvert()
    var isCurrencyToConvert = false
    
    var arrayCurrencies = [CurrencyModel]()
    
    var currencyFromConvertName: String?
    var currencyToConvertName: String?
}

