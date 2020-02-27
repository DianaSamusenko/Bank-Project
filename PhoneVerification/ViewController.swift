//
//  ViewController.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class ViewController: UIViewController {

    @IBOutlet weak var countryCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var smsCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(textField: countryCodeTextField, color: #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1))
        configureTextField(textField: phoneNumberTextField, color: #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1))
        configureTextField(textField: smsCodeTextField, color: #colorLiteral(red: 0.8745098039, green: 0.9019607843, blue: 0.9137254902, alpha: 1))
        
//        let attributedString = NSMutableAttributedString.init(string: "Apply UnderLining")
//        attributedString.addAttribute(.link, value: "https://www.google.com/?client=safari&channel=mac_bm", range: NSRange.init(location: 0, length: attributedString.length))
//        bottomLabel.attributedText = attributedString
//        
        configureButtonState(value: false)
        sendSMSButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        phoneNumberTextField.delegate = self
    }
    
    private func configureButtonState(value: Bool) {
        sendSMSButton.isEnabled = value
        sendSMSButton.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        
    }
    
    func configureTextField(textField: SkyFloatingLabelTextField!, color: CGColor) {
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = color
        textField.lineHeight = 0
        textField.selectedLineHeight = 0
        self.view.addSubview(textField)
        textField.selectedTitleColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
    }

    @IBAction func sendSMSPressed(_ sender: UIButton) {
    }
    
    
}

extension ViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
         
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if phoneNumberTextField.text!.count > 0 {
            configureButtonState(value: true)
        } else {
            configureButtonState(value: false)
        }
        
        return true
    }
}

