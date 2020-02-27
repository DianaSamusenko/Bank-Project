//
//  CountryCodeTableViewCell.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import UIKit
import Kingfisher

class CountryCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(model: CodeModel?) {
        
        guard let model = model else { return }
        let url = URL(string: "https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/" + model.imageUrl!)
        
        countryNameLabel.text = model.name
        codeLabel.text = model.phoneFormats![0].code
        flagImageView.kf.setImage(with: url)
    }
}
