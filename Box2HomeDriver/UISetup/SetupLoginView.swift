//
//  SetupLoginTextField.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/18/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SetupLoginView: NSObject {
    
     static let sharedInstance : SetupLoginView = SetupLoginView()
    
    func SetupActivityIndicator(loading: NVActivityIndicatorView) {
            loading.type = NVActivityIndicatorType.ballPulse
            loading.startAnimating()
            loading.color = .white
        
    }
    
    func SetupTextField(TelephoneTF: UITextField) {
        let placeholderPaddingLeft = 15
        TelephoneTF.layer.borderColor = UIColor(displayP3Red: (255/255), green: 255/255, blue: 255/255, alpha: 1).cgColor
        TelephoneTF.layer.borderWidth = 1
        TelephoneTF.layer.cornerRadius = TelephoneTF.frame.size.height/4
        TelephoneTF.backgroundColor = UIColor.clear
        TelephoneTF.tintColor = UIColor.white
        TelephoneTF.textColor = UIColor.white
        TelephoneTF.placeholder = "Numéro de téléphone"
        TelephoneTF.attributedPlaceholder = NSAttributedString(string: TelephoneTF.placeholder!, attributes:[NSAttributedString.Key.foregroundColor : UIColor(white: 1.0, alpha: 1)])
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: placeholderPaddingLeft, height: 20))
        TelephoneTF.leftView = paddingView
        TelephoneTF.leftViewMode = .always
    }
    
    func SetupOkButton(OkButton: UIButton, vc:UIViewController) {
        OkButton.setTitle("OK", for: .normal)
        OkButton.backgroundColor = UIColor.white
        OkButton.tintColor = vc.view.backgroundColor
        OkButton.layer.cornerRadius = OkButton.frame.size.height/4
    }
    func SetupLogo(logo:UIImageView) {
        logo.contentMode = .scaleAspectFit
        logo.backgroundColor = .white
        logo.layer.cornerRadius = logo.frame.size.height/13
        logo.image = UIImage(named: "logo")
    }
    func SetupBackgroundColor(vc: UIViewController) {
        vc.view.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
    }
    override init() {
         super.init()
        
    }
}
