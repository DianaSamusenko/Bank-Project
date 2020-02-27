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


class CountryCodeViewController: UIViewController {
    
    
    var codeModel: [CodeModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let provider = MoyaProvider<CodeAPI>()
    typealias RequestResult = ((AnyObject?, Error?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCodes()
        print("Hey   \(codeModel.count)")
        
        tableView.register(UINib(nibName: "CountryCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tableView.separatorStyle = .none
        
//        cardTableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private func getCodes() {
        self.provider.request(.codes) { result in
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try result.get()
                    if response.data.count > 0{
                        let result = try response.mapJSON() as! [[String: Any]]
                        
                        
                        self.codeModel = Mapper<CodeModel>().mapArray(JSONArray: result)
                        print(self.codeModel)
                        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountryCodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCodeTableViewCell
        
        cell.configureCell(model: codeModel[indexPath.row])
        
//        if let double = codeModel[indexPath.row].officialRate {
//            cell.curOfficialRateLabel.text =  String(describing: double)
//        } else {
//            cell.curOfficialRateLabel.text = nil
//        }
        return cell
    }
    
    
}
