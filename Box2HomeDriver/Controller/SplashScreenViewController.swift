//
//  SplashScreenViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/15/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftEventBus

class SplashScreenViewController: UIViewController {
    //Local Variables
    // Dependecies
    let viewModel = SplashScreenViewModel(SplashScreenRepository: SplashScreenRepository())
    //IBOutlets
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
   
    //--------------------------------------------------------------------------------------------
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        SystemVersioning()
        InternetObserver()
        InternetChecking()
    }
    //--------------------------------------------------------------------------------------------
    fileprivate func setupView (){
        SetupSplashScreenView.sharedInstance.SetupBackgroundColor(vc: self)
        SetupLogo()
        SetupLoading()
        
    }
    fileprivate func SetupLogo() {
        SetupSplashScreenView.sharedInstance.SetupLogo(logo: logo)
    }
    fileprivate func SetupLoading() {
        SetupSplashScreenView.sharedInstance.SetupActivityIndicator(loading: loadingView)
    }
    //------------------------------------------
    fileprivate func InternetObserver() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
    }
     fileprivate func InternetChecking() {
        viewModel.CheckInternet()
    }
    @objc func statusManager(_ notification: Notification) {
       InternetChecking()
    }
    //------------------------------------------

    fileprivate func SystemVersioning() {
        viewModel.CheckVersion()
        viewModel.showErrorClosure  = {
            if let error = self.viewModel.error {
                let alert = UIAlertController(title: "Attention", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
            }
        }
        viewModel.showGoodVersionClosure  = {
            if let message = self.viewModel.GoodVersionMessage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        print(message)
                        self.performSegue(withIdentifier: "SplashToLogin", sender: self)
                }
            }
        }
        viewModel.showBadVersionClosure  = {
            if let message = self.viewModel.BadVersionMessage {
                print(message)
            
            }
        }
    }
}

