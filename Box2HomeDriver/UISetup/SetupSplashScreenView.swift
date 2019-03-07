//
//  SetupSplashScreenView.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/18/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SetupSplashScreenView: NSObject {
    static let sharedInstance : SetupSplashScreenView = SetupSplashScreenView()
    
  
  

    
    func SetupActivityIndicator(loading: NVActivityIndicatorView) {
        loading.type = NVActivityIndicatorType.ballPulse
        loading.startAnimating()
    }
    
    func SetupProgressBar(progressBar: UIProgressView, vc:UIViewController) {
        progressBar.setProgress(0, animated: false)
        progressBar.tintColor = .white
        progressBar.trackTintColor = vc.view.backgroundColor 
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
