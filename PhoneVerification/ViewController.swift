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
//    @IBOutlet weak var codeView: UIView!
//    @IBOutlet weak var smsCodeView: UIView!
//    @IBOutlet weak var phoneNumberView: UIView!
    
    @IBOutlet weak var sendSMSButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //countryCodeTextField.borderStyle = UITextBorderStyle.
        
//        countryCodeTextField.layer.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
//        phoneNumberTextField.layer.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
//        smsCodeTextField.layer.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        
        
//        codeView.layer.borderColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
//        smsCodeView.layer.borderColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
//        phoneNumberView.layer.borderColor = #colorLiteral(red: 0.6980392157, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        
        configureButtonState(value: false)
//        sendSMSButton.isEnabled = false
        sendSMSButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        countryCodeTextField.placeholder = "Code"
        countryCodeTextField.title = "Code"
        self.view.addSubview(countryCodeTextField)
        countryCodeTextField.selectedTitleColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        countryCodeTextField.selectedLineColor = .white
        //countryCodeTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
//        countryCodeTextField.iconType = .font
//        countryCodeTextField.iconFont = UIFont(name: "FontAwesome", size: 15)
        
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.title = "Phone Number"
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.selectedTitleColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        phoneNumberTextField.selectedLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //phoneNumberTextField.bounds = CGColor(srgbRed: 0.518, green: 0.58, blue: 0.604, alpha: 1) as! CGRect
        phoneNumberTextField.delegate = self
        
        smsCodeTextField.placeholder = "SMS Code"
        smsCodeTextField.title = "SMS Code"
        self.view.addSubview(smsCodeTextField)
        smsCodeTextField.lineColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        smsCodeTextField.selectedTitleColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        smsCodeTextField.selectedLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        smsCodeTextField.borderStyle = .roundedRect
        
//        let string  = phoneNumberTextField.text
//        if string?.count == 8 {
//            sendSMSButton.isEnabled = true
//            sendSMSButton.backgroundColor = #colorLiteral(red: 0, green: 0.5980514884, blue: 0.9129410386, alpha: 1)
//        }
        
//        if (phoneNumberTextField!.text != nil) {
//            sendSMSButton.isEnabled = true
//            sendSMSButton.backgroundColor = #colorLiteral(red: 0, green: 0.5980514884, blue: 0.9129410386, alpha: 1)
//        }
        //print(phoneNumberTextField.text)
        
    }
    
    private func configureButtonState(value: Bool) {
        sendSMSButton.isEnabled = value
        sendSMSButton.backgroundColor = .red
        
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

