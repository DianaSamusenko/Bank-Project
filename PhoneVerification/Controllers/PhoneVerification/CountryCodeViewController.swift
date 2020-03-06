//
//  CountryCodeViewController.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

typealias RequestResult = ((AnyObject?, Error?) -> Void)?

protocol PhoneFormatsCodeDelegate {
    func makeCode(model: CountryModel?)
}

class CountryCodeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countryModel: [CountryModel] = []
    var codeModelTemp: [CountryModel] = []
    var searching = false
    
    var delegate: PhoneFormatsCodeDelegate?
    
    let provider = MoyaProvider<CodeAPI>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        getCodes()
        createTableView()
    }
    
    private func createTableView() {
        tableView.register(UINib(nibName: "CountryCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getCodes() {
        self.provider.request(.codes) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try result.get()
                    if response.data.count > 0 {
                        let result = try response.mapJSON() as! [[String: Any]]
                        
                        self.countryModel = Mapper<CountryModel>().mapArray(JSONArray: result)
                        self.codeModelTemp = self.countryModel
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                catch {
                    print("error")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - TableViewDelegate DataSource

extension CountryCodeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCodeTableViewCell
        
        cell.configureCell(model: countryModel[indexPath.row])
        cell.accessoryType = countryModel[indexPath.row].selected ? .checkmark : .none
        
        if countryModel[indexPath.row].selected == false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if countryModel[indexPath.row].selected == false {
            countryModel[indexPath.row].selected = true
        } else {
            countryModel[indexPath.row].selected = false
        }
        
        self.delegate?.makeCode(model: countryModel[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension CountryCodeViewController: UISearchBarDelegate {
    func search(searchResult: String) {
        countryModel = codeModelTemp.filter({
            if(($0.name?.contains(searchResult))!) || (($0.phoneFormats![0].code?.contains(searchResult))!){
                return true
            }
            return false
        })
        if searchResult == "" {
            countryModel = codeModelTemp
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchResult: searchText)
    }
}
