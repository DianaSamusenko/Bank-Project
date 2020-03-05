//
//  ViewController.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import InputMask
import Moya

//typealias RequestResult = ((AnyObject?, Error?) -> Void)?

class ViewController: UIViewController {
    
    @IBOutlet var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var countryCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var smsCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var code: String?
    var maskFirst: String = "(000) 000 00 00"
    var imageURLString: String?
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
     let provider = MoyaProvider<CodeAPI>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeArrowImage()
        configureTextField()
        
        self.view.endEditing(true)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func getSmsCode() {
        
        let countryCode = countryCodeTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        var fullNumber: String {
            get {
                return countryCode + phoneNumber
            }
        }
        
        provider.request(.smsCodes(hash: "", phoneNumber: fullNumber, type: "SMS")) { result in
            
        }
    }
    
    private func createMask() {
        var mask = maskFirst
        mask = "[" + mask
        mask = mask.replacingOccurrences(of: "[(", with: "([")
        mask = mask.replacingOccurrences(of: "-", with: "]-[")
        mask = mask.replacingOccurrences(of: " ", with: "] [")
        mask = mask.replacingOccurrences(of: ")", with: "])[")
        mask = mask.replacingOccurrences(of: "#", with: "0")
        mask = mask + "]"
        
        print(mask)
        
        listener.delegate = self
        listener.affinityCalculationStrategy = .wholeString
        listener.affineFormats = [mask]
        print(mask.count)
    }
    
    @objc func didTapView() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        navigationController?.pushViewController(viewController, animated: true)
        viewController.delegate = self
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configureButtonState(value: Bool) {
        sendSMSButton.isEnabled = value
    }
    
    func configureTextField() {
        
        let borderWidth: CGFloat = 1
        let cornerRadius: CGFloat = 4
        let lineHeight: CGFloat = 0
        let selectedLineHeight: CGFloat = 0
        let roundedRect: UITextField.BorderStyle = .roundedRect
        
        countryCodeTextField.layer.borderWidth = borderWidth
        countryCodeTextField.layer.cornerRadius = cornerRadius
        countryCodeTextField.lineHeight = lineHeight
        countryCodeTextField.selectedTitleColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        countryCodeTextField.layer.borderColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        countryCodeTextField.borderStyle = roundedRect
        countryCodeTextField.titleFormatter = {$0}
        countryCodeTextField.text = code
        countryCodeTextField.addTarget(self, action: #selector(didTapView), for: .editingDidBegin)
        
        phoneNumberTextField.layer.borderWidth = borderWidth
        phoneNumberTextField.layer.cornerRadius = cornerRadius
        phoneNumberTextField.lineHeight = lineHeight
        phoneNumberTextField.selectedLineHeight = selectedLineHeight
        phoneNumberTextField.selectedTitleColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        phoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        phoneNumberTextField.borderStyle = roundedRect
        phoneNumberTextField.titleFormatter = {$0}
        phoneNumberTextField.delegate = listener
        
        smsCodeTextField.layer.borderWidth = borderWidth
        smsCodeTextField.layer.cornerRadius = cornerRadius
        smsCodeTextField.lineHeight = lineHeight
        smsCodeTextField.selectedLineHeight = selectedLineHeight
        smsCodeTextField.selectedTitleColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        smsCodeTextField.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.9019607843, blue: 0.9137254902, alpha: 1)
        smsCodeTextField.borderStyle = roundedRect
        smsCodeTextField.titleFormatter = {$0}
        smsCodeTextField.delegate = self
        
        configureButtonState(value: false)
    }
    
    @IBAction func sendSMSPressed(_ sender: UIButton) {
        timer.invalidate()
        runTimer()
        
        getSmsCode()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        sendSMSButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "We sent you secure code. If you did not get it, you can resend it in \(seconds) sec"
    }
    
    @objc func textFieldDidChange() {
        
        if (phoneNumberTextField.text?.count == maskFirst.count && smsCodeTextField.text?.count == 4 && countryCodeTextField.text != "") {
            phoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.8588235294, blue: 0.7882352941, alpha: 1)
            smsCodeTextField.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.8588235294, blue: 0.7882352941, alpha: 1)
            countryCodeTextField.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.8588235294, blue: 0.7882352941, alpha: 1)
        } else if (phoneNumberTextField.text?.count == maskFirst.count && countryCodeTextField.text != "") {
            sendSMSButton.isEnabled = true
            sendSMSButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    
    func makeCodeTextField(imageName: String) {
        countryCodeTextField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        let url = URL(string: "https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/" + imageName)
        
        imageView.kf.setImage(with: url)
        
        let imageContainer = UIView(frame: CGRect(x: 40, y: 40, width: 30, height: 30))
        imageContainer.addSubview(imageView)
        
        countryCodeTextField.leftView = imageContainer
    }
    
    func makeArrowImage() {
        countryCodeTextField.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "arrow drop down")
        imageView.image = image
        countryCodeTextField.rightView = imageView
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //
        //        if phoneNumberTextField.text!.count > 0 {
        //            configureButtonState(value: true)
        //        } else {
        //            configureButtonState(value: false)
        //        }
        //
        return true
    }
    
    func activateSendSms() {
        if (phoneNumberTextField.text?.count == maskFirst.count && countryCodeTextField.text != "") {
            sendSMSButton.isEnabled = true
            sendSMSButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1)
        
        if phoneNumberTextField.endEditing(true) {
            activateSendSms()
        }
        smsCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
}

extension ViewController: PhoneFormatsCodeDelegate {
    func makeCode(model: CountryModel?) {
        guard let model = model, let imageURl = model.imageUrl, let phoneFormats = model.phoneFormats else { return }
        let phones: [PhoneFormats] = phoneFormats
        for s in phones {
            countryCodeTextField.text = s.code
            maskFirst = s.mask ?? "(000) 000 00 00"
            createMask()
            print(maskFirst)
        }
        imageURLString = imageURl
        makeCodeTextField(imageName: imageURLString!)
    }
}

extension ViewController: MaskedTextFieldDelegateListener {
    
    func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        print(value)
    }
}
