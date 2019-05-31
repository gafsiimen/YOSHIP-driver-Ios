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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SplashToHome" {
//            if let viewController = segue.destination as? HomeViewController {
//                viewController.toggleSideMenuView()
//                viewController.toggleSideMenuView()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        SystemVersioning()
       
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
     fileprivate func InternetChecking() {
        viewModel.CheckInternet()
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
        viewModel.didFinishFetch = {
            if let response = self.viewModel.resp {
                SessionManager.currentSession.reconnectResponse = response
//                print("RECONNECT RESPONSE IS SET !!")
            }
        }
        viewModel.showGoodVersionClosure  = {
           
             let sessionState = UserDefaults.standard.bool(forKey: "sessionState")
            switch sessionState {
            case true:
                if let phone = RealmManager.sharedInstance.fetchResponse().first?.authToken?.chauffeur?.phone{
//                    print("STORED PHONE : ",phone)
                    self.viewModel.Login(phone: phone)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.performSegue(withIdentifier: "SplashToHome", sender: self)
                    }
                }
                    else {
                        print("STORED PHONE IS NIL")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.performSegue(withIdentifier: "SplashToLogin", sender: self)
                    }
                }
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            self.performSegue(withIdentifier: "SplashToLogin", sender: self)
//                        }
//                }

               
                
            case false:
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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

