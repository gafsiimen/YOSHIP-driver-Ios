//
//  LoginViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/15/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import SwiftEventBus
import NVActivityIndicatorView
import  SocketIO
class LoginViewController: UIViewController {

     //Local Variables
    
     //Dependecies
    let viewModel = LoginViewModel(LoginRepository: LoginRepository())
     //IBOutlets
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var TelephoneTF: UITextField!
    @IBOutlet weak var OkButton: UIButton!
    @IBOutlet weak var Loading: NVActivityIndicatorView!
    //--------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        InternetObserver()
//        InternetChecking()
    }
//    fileprivate func InternetChecking() {
//        viewModel.CheckInternet(vc: self)
//    }
//    @objc func statusManager(_ notification: Notification) {
//        InternetChecking()
//    }
//    fileprivate func InternetObserver() {
//        NotificationCenter.default
//            .addObserver(self,
//                         selector: #selector(statusManager),
//                         name: .flagsChangedLogin,
//                         object: nil)
//    }
    //--------------------------------------------------------------------------------------------
    fileprivate func setupView (){
       
        SetupLoginView.sharedInstance.SetupBackgroundColor(vc:self)
        SetupLogo()
        SetupTextField()
        SetupOkButton()
       
    }
    fileprivate func SetupLogo() {
        SetupLoginView.sharedInstance.SetupLogo(logo: logo)
    }
    fileprivate func SetupTextField() {
        SetupLoginView.sharedInstance.SetupTextField(TelephoneTF: TelephoneTF)
    }
    fileprivate func SetupOkButton() {
        SetupLoginView.sharedInstance.SetupOkButton(OkButton: OkButton,vc:self)
    }
    @IBAction func OkButton(_ sender: Any) {
        attemptLogin()
    }
    fileprivate func SetupLoading() {
        SetupLoginView.sharedInstance.SetupActivityIndicator(loading: Loading)
    }
   
    private func attemptLogin(){
        
        SetupLoading()
        viewModel.Login(phone: self.TelephoneTF.text! as String)
        
      
        viewModel.didFinishFetch = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("VALID USER !!")
                UIView.setAnimationsEnabled(false)
                self.performSegue(withIdentifier: "LoginToHome", sender: self)
                UIView.setAnimationsEnabled(true)
            }
            
        }
        viewModel.showErrorClosure = {
             if let error = self.viewModel.error {
                let alert = UIAlertController(title: "Attention", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
            }
        }
        viewModel.InvalidClosure = {
            if let message = self.viewModel.InvalidMessage {
                let alert = UIAlertController(title: "Attention", message: "\(message)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
            }
        }
    
    viewModel.Go2Box2Home = {
                if let message = self.viewModel.Go2Box2HomeMessage {
                let alert = UIAlertController(title: "Attention", message: "\(message)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
      }
    }
    viewModel.showEmptyErrorClosure = {
                if let message = self.viewModel.EmptyErrorMessage {
                let alert = UIAlertController(title: "Attention", message: "\(message)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
            }
      }
  }
}
