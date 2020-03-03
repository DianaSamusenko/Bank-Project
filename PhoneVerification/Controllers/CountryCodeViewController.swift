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

protocol CodeDelegate {
    func makeCode(model: CodeModel?)
}

class CountryCodeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var codeModel: [CodeModel] = []
    var codeModelTemp: [CodeModel] = []
    var searchData = [String]()
    var countryNameArary = [String]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: CodeDelegate?
    
    let provider = MoyaProvider<CodeAPI>()
    typealias RequestResult = ((AnyObject?, Error?) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        getCodes()
        
        tableView.register(UINib(nibName: "CountryCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        definesPresentationContext = true
    }
    
    private func getCodes() {
        self.provider.request(.codes) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try result.get()
                    if response.data.count > 0 {
                        let result = try response.mapJSON() as! [[String: Any]]
                        
                        self.codeModel = Mapper<CodeModel>().mapArray(JSONArray: result)
                        self.codeModelTemp = self.codeModel
                        self.makeArary(self.codeModel)
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
    
    func makeArary(_ codeModel: [CodeModel]) {
        for i in 0..<codeModel.count {
            self.countryNameArary.append(codeModel[i].name!)
        }
    }
}

//MARK: - TableViewDelegate DataSource

extension CountryCodeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCodeTableViewCell
        
        cell.configureCell(model: codeModel[indexPath.row])
        cell.accessoryType = codeModel[indexPath.row].selected ? .checkmark : .none
        
        if codeModel[indexPath.row].selected == false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if codeModel[indexPath.row].selected == false {
            codeModel[indexPath.row].selected = true
        } else {
            codeModel[indexPath.row].selected = false
        }
        
        self.delegate?.makeCode(model: codeModel[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension CountryCodeViewController: UISearchBarDelegate {
    func search(searchResult: String) {
        codeModel = codeModelTemp.filter({
            if(($0.name?.contains(searchResult))!) || (($0.phoneFormats![0].code?.contains(searchResult))!){
                return true
            }
            return false
        })
        if searchResult == "" {
            codeModel = codeModelTemp
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchResult: searchText)
    }
}
