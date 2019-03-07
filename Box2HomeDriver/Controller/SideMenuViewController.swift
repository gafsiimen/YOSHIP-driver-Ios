//
//  SideMenuViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/19/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    var header =  UIImageView()
    var avatar =  UIImageView()
    var label1 =  UILabel()
    var label2 =  UILabel()
    var Button1 = UIButton(type: .system)
    var Button2 = UIButton(type: .system)
    var Button3 = UIButton(type: .system)
    var Button4 = UIButton(type: .system)
    var Button5 = UIButton(type: .system)
    var Button6 = UIButton(type: .system)
    var separator = UIView()
    
    let menuWidth = CGFloat(300)
    let headerHeight = UIScreen.main.bounds.height/3
    let avatarY = UIScreen.main.bounds.height/10
    let avatarWidth = CGFloat(80)
    let avatarHeight = CGFloat(80)
    let label1Y = UIScreen.main.bounds.height/4
    let label2Y = UIScreen.main.bounds.height/3.5
    let labelHeight = CGFloat(20)
    let labelWidth = CGFloat(160)
    let PaddingLeft = CGFloat(30)
    let SectionDistance = CGFloat(30)
    let base = UIScreen.main.bounds.height/2.9
    let unit = UIScreen.main.bounds.height/16
    let offset = CGFloat(10)
    //---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //---------------
        header.frame = CGRect(x: 0, y: 0, width: menuWidth, height: headerHeight)
        header.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        header.layer.shadowColor = UIColor(ciColor: .black).cgColor
        header.layer.shadowOffset = CGSize(width: 0, height: 1);
        header.layer.shadowOpacity = 1;
        header.layer.shadowRadius = 1.0;
        header.clipsToBounds = false;
        //---------------
        avatar.frame = CGRect(x: PaddingLeft ,y: avatarY, width: avatarWidth, height: avatarHeight)
        avatar.layer.cornerRadius = avatarHeight/2
        avatar.backgroundColor = .red
        avatar.layer.shadowColor = UIColor(ciColor: .black).cgColor
        avatar.layer.shadowOffset = CGSize(width: 0, height: 1);
        avatar.layer.shadowOpacity = 0.5;
        avatar.layer.shadowRadius = 1.0;
        avatar.clipsToBounds = false;
        //---------------
        label1.frame = CGRect(x: PaddingLeft, y: label1Y , width: labelWidth, height: labelHeight)
        label1.text = "Nom Prénom"
        label1.textColor = .white
        //---------------
        label2.frame = CGRect(x: PaddingLeft, y: label2Y , width: labelWidth, height: labelHeight)
        label2.text = "Fonction"
        label2.textColor = .white
        label2.font = UIFont(name: label2.font.fontName, size: 14)
        //---------------
        Button1.frame = CGRect(x: 0, y: base, width: menuWidth, height: unit)
        Button1.setTitle("Mes courses", for: .normal)
        Button1.tintColor = .darkGray
        Button1.addTarget(self,action: #selector(Button1Action),for: .touchUpInside)
        //---------------
       
        //---------------
        Button2.frame = CGRect(x: 0, y: base + unit + offset, width: menuWidth, height: unit)
        Button2.setTitle("Mes informations", for: .normal)
        Button2.tintColor = .darkGray
        Button2.addTarget(self,action: #selector(Button2Action),for: .touchUpInside)
        //---------------
        Button3.frame = CGRect(x: 0, y: base + 2*(unit + offset), width: menuWidth, height: unit)
        Button3.setTitle("Mon historique", for: .normal)
        Button3.tintColor = .darkGray
        Button3.addTarget(self,action: #selector(Button3Action),for: .touchUpInside)
        //---------------
        separator.frame = CGRect(x: 0, y:  base + 2*offset+3*unit + (SectionDistance+offset)/2,  width: menuWidth, height: 1)
        separator.backgroundColor = .darkGray
        separator.layer.shadowColor = UIColor(ciColor: .black).cgColor
        separator.layer.shadowOffset = CGSize(width: 0, height: 0.1);
        separator.layer.shadowOpacity = 0.4;
        separator.layer.shadowRadius = 0.5;
        separator.clipsToBounds = false;
        //---------------
        Button4.frame = CGRect(x: 0, y: base + 3*(unit + offset)+SectionDistance, width: menuWidth, height: unit)
        Button4.setTitle("Déconnexion", for: .normal)
        Button4.tintColor = .darkGray
        Button4.addTarget(self,action: #selector(Button4Action),for: .touchUpInside)
        //---------------
        Button5.frame = CGRect(x: 0, y: base + 4*(unit + offset)+SectionDistance, width: menuWidth, height: unit)
        Button5.setTitle("Mention légale", for: .normal)
        Button5.tintColor = .darkGray
        Button5.addTarget(self,action: #selector(Button5Action),for: .touchUpInside)
        //---------------
        Button6.frame = CGRect(x: 0, y: base + 5*(unit + offset)+SectionDistance, width: menuWidth, height: unit)
        Button6.setTitle("À propos", for: .normal)
        Button6.tintColor = .darkGray
        Button6.addTarget(self,action: #selector(Button6Action),for: .touchUpInside)
        //---------------
        view.addSubview(header)
        view.addSubview(avatar)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(Button1)
        view.addSubview(Button2)
        view.addSubview(Button3)
        view.addSubview(separator)
        view.addSubview(Button4)
        view.addSubview(Button5)
        view.addSubview(Button6)

    }
    
    @objc func Button1Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func Button2Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MesInformations")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func Button3Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MonHistorique")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func Button4Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Déconnexion")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func Button5Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MentionLégale")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func Button6Action(){
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Apropos")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }

}
