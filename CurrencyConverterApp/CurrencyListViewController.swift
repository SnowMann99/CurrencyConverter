//
//  CurrencyListViewController.swift
//  CurrencyConverterApp
//
//  Created by Egor Salnikov on 27.05.2021.
//

import UIKit

final class CurrencyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - Properties
    
    var currencyToConvert: CurrenciesToConvert!
    var filteredCurrencies = [CurrencyModel]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        currencyToConvert = CurrenciesToConvert.shared
        filteredCurrencies = currencyToConvert.arrayCurrencies
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = filteredCurrencies[indexPath.row].id
        cell?.detailTextLabel?.text = filteredCurrencies[indexPath.row].currencyName
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
        
        if currencyToConvert.isCurrencyToConvert {
            currencyToConvert.currencyToConvertName = filteredCurrencies[indexPath.row].id
        } else {
            currencyToConvert.currencyFromConvertName = filteredCurrencies[indexPath.row].id
        }
    }
    
    //MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCurrencies = currencyToConvert.arrayCurrencies.filter({$0.id.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.currencyName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        tableView.reloadData()
        
        }
    }
