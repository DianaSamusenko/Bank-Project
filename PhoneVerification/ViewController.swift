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
import MessageUI

class ViewController: UIViewController, MaskedTextFieldDelegateListener, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    @IBOutlet weak var countryCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var smsCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendSMSButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var code: String?
    var imageURLString: String?
    var maskedDelegate: MaskedTextFieldDelegate!
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskedDelegate = MaskedTextFieldDelegate()
        maskedDelegate.listener = self
        phoneNumberTextField.delegate = maskedDelegate
        maskedDelegate.put(text: "{(}[000]{)}[000]{-}[000]", into: phoneNumberTextField)
        
        
        makeArrowImage()
        
        countryCodeTextField.text = code
        
        configureTextField(textField: countryCodeTextField, color: #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1))
        configureTextField(textField: phoneNumberTextField, color: #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6039215686, alpha: 1))
        configureTextField(textField: smsCodeTextField, color: #colorLiteral(red: 0.8745098039, green: 0.9019607843, blue: 0.9137254902, alpha: 1))
        
        configureButtonState(value: false)
        sendSMSButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        phoneNumberTextField.delegate = self
        
        countryCodeTextField.addTarget(self, action: #selector(didTapView), for: .editingDidBegin)
    }
    
    @objc func didTapView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CountryCodeViewController") as! CountryCodeViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
        self.view.endEditing(true)
    }
    
    private func configureButtonState(value: Bool) {
        sendSMSButton.isEnabled = value
        sendSMSButton.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        
    }
    
    func configureTextField(textField: SkyFloatingLabelTextField!, color: CGColor) {
        textField.titleFormatter = {$0}
        
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
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [countryCodeTextField.text! + phoneNumberTextField.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            print("SMS service is not available")
        }
//        configureButtonState(value: true)
//        sendSMSButton.titleLabel = "Resend SMS"
//        sendSMSButton.titleLabel = UILabel("Resend SMS")
//        sendSMSButton.isEnabled = false
        timer.invalidate()
//        sendSMSButton.isEnabled = false
        runTimer()
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        sendSMSButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "We sent you secure code. If you did not get it, you can resend it in \(seconds) sec"
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

extension ViewController: CodeDelegate {
    func makeCode(model: CodeModel?) {
        guard let model = model, let name = model.name, let imageURl = model.imageUrl, let phoneFormats = model.phoneFormats else { return }
        var phones: [PhoneFormats] = phoneFormats
        for s in phones {
            
            print(s.mask)
            countryCodeTextField.text = s.code
        }
        imageURLString = imageURl
        makeCodeTextField(imageName: imageURLString!)
        
    }
    
}

