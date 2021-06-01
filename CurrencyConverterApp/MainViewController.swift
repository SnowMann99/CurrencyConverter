//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 26.05.2021.
//

import UIKit

final class MainViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var convertFrom: UILabel!
    @IBOutlet weak var convertTo: UILabel!
    
    @IBOutlet weak var volumeOfCurrency: UITextField!
    @IBOutlet weak var resultOfConvertation: UITextField!
    
    var isReverseConvertNeeded = false
    var isReadyToConvertation = false
    
    var volume = 1.0
    var results = 1.0
    
    var currencyList: Results?
    var link: CurrenciesToConvert!
    
    var updatingView = UpdatingView()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        updateValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatingView.show()
        
        link = CurrenciesToConvert.shared
        beginLoading()
    }
    
    //MARK: - Actions
    
    @IBAction func currencyFromConvert(_ sender: UIButton) {
        takeCurrency()
        link.isCurrencyToConvert = false
    }
    
    @IBAction func currencyToConvert(_ sender: UIButton) {
        takeCurrency()
        link.isCurrencyToConvert = true
    }
    
    @IBAction func convertButton(_ sender: UIButton) {
        isReadyToConvert()
        guard let convertFrom = link.currencyFromConvertName, let convertTo = link.currencyToConvertName else { return }
        
        if isReverseConvertNeeded && isReadyToConvertation  {
            convert(from: convertTo, to: convertFrom)
        } else if isReadyToConvertation {
            convert(from: convertFrom, to: convertTo)
        }
    }
    
    @IBAction func fromConvertField(_ sender: UITextField) {
    }
    
    @IBAction func toConvertField(_ sender: UITextField) {
    }
    
    //MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharactersSet = CharacterSet(charactersIn: allowedCharacters)
        
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharactersSet.isSuperset(of: typedCharacterSet)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if volumeOfCurrency.isEditing {
            resultOfConvertation.text = ""
            
        } else if resultOfConvertation.isEditing {
            volumeOfCurrency.text = ""
        }
        
    }
    
    //MARK: - Private Functions
    
    private func isReadyToConvert() {
        
        guard let volumeText = volumeOfCurrency.text, let resultText = resultOfConvertation.text else { return }
        let isCurrenciesPicked = link.currencyFromConvertName != nil && link.currencyToConvertName != nil
        
        if isCurrenciesPicked && volumeText.isEmpty && !resultText.isEmpty {
            isReverseConvertNeeded = true
            isReadyToConvertation = true
            
        } else if isCurrenciesPicked && !volumeText.isEmpty && resultText.isEmpty {
            isReverseConvertNeeded = false
            isReadyToConvertation = true
            
        } else if isCurrenciesPicked && !volumeText.isEmpty && !resultText.isEmpty {
            isReverseConvertNeeded = false
            isReadyToConvertation = true
            
        } else {
            isReadyToConvertation = false
            
            let alert = UIAlertController(title: "Заполните поля", message: "Для конвертации необходимо выбрать обе валюты и ввести сумму.", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateValues() {
        var fromValue = convertFrom.text
        var toValue = convertTo.text
        
        if fromValue != link.currencyFromConvertName {
            fromValue = link.currencyFromConvertName
            resultOfConvertation.text = ""
            
            convertFrom.text = fromValue
        } else if toValue != link.currencyToConvertName {
            toValue = link.currencyToConvertName
            resultOfConvertation.text = ""
            
            convertTo.text = toValue
        }
    }
    
    private func beginLoading() {
        NetworkHelper.instance.getData().then { [self] result in
            currencyList = result
            updatingView.hide()
            
            let sortedDict = currencyList?.results.sorted { $0.key < $1.key }
            
            for (_,value) in sortedDict! {
                link.arrayCurrencies.append(value)
            }
        }.catch { error in
            
            self.showNetworkError()
            print("Возникла ошибка \(error.localizedDescription) по причине \(error.reason)")
        }
    }
    
    private func convert(from: String, to: String) {
        NetworkHelper.instance.convertCurrencies(from: from, to: to).then { [self] result in
            var rate: Double?
            
            volumeOfCurrency.endEditing(true)
            resultOfConvertation.endEditing(true)
            
            if let vol = volumeOfCurrency.text {
                if !vol.isEmpty {
                    volume = Double(vol) ?? 0
                }
            }
            
            if let result = resultOfConvertation.text {
                if !result.isEmpty {
                    results = Double(result) ?? 0
                }
            }
            
            for (_,value) in result {
                rate = value
            }
            
            if let rateValue = rate {
                if isReverseConvertNeeded {
                    let result = results * rateValue
                    let resultToShow = String(format: "%.2f", result)
                    
                    volumeOfCurrency.text = resultToShow
                    
                } else {
                    let result = volume * rateValue
                    let resultToShow = String(format: "%.2f", result)
                    
                    resultOfConvertation.text = resultToShow
                }
                
            }
            
        }.catch { error in
            self.showNetworkError()
            print("Возникла ошибка \(error.localizedDescription) по причине \(error.reason)")
        }
    }
    
    private func takeCurrency() {
        
        let imageViewController = UIStoryboard(name: "CurrencyList", bundle: nil).instantiateViewController(withIdentifier: "CurrencyListViewController")
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    private func showNetworkError() {
        let alert = UIAlertController(title: "Ошибка", message: "Вероятно, отсутствует соединение с интернетом", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
