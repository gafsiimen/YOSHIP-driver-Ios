//
//  CourseDetailsController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 4/2/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit
import GoogleMaps
import UberSignature
import LTHRadioButton
import AVFoundation
import DKCamera
import NVActivityIndicatorView

class CourseDetailsController: UIViewController, SignatureDrawingViewControllerDelegate, ENSideMenuDelegate {
    
    
    
    let viewModel = CourseDetailViewModel(CourseDetailRepository: CourseDetailRepository())
    private let signatureViewController = SignatureDrawingViewController()
    //----------
    //classes
    class OuiNonButton: UIButton {
        var yes = Bool()
        var phase = String()
    }
    class MyCauseLabelTap: UITapGestureRecognizer {
        var param = String()
    }
    //---------
    var mapView = GMSMapView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var bottomViewHeightConstraint: NSLayoutConstraint!
    var lowHeight:CGFloat = 155
    var confirmationHeight: CGFloat = 160
    var highHeight:CGFloat = 300
    //---------
    //data from HomeViewController
    //> for views
    var statusCode:String = ""
    var latitudeDepart:Double = 0
    var longitudeDepart:Double = 0
    var latitudeArrivee:Double = 0
    var longitudeArrivee:Double = 0
    var adresseDepart: String = ""
    var adresseArrivee: String = ""
    var codeCorner: String = ""
    var courseSource: String = ""
    
    var codeCourse:String = "" {
        didSet{
            let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
            self.statusCode = course.status?.code ?? ""
            self.adresseDepart = course.adresseDepart?.address ?? ""
            self.adresseArrivee = course.adresseArrivee?.address ?? ""
            self.codeCorner = course.codeCorner ?? ""
            self.courseSource = course.courseSource ?? ""
            self.latitudeDepart = course.adresseDepart?.latitude.value ?? 0.0
            self.longitudeDepart = course.adresseDepart?.longitude.value ?? 0.0
            self.latitudeArrivee = course.adresseArrivee?.latitude.value ?? 0.0
            self.longitudeArrivee = course.adresseArrivee?.longitude.value ?? 0.0
        }
    }
   
    //---------
    //local
    var selectedType = "Habitat"
    var CancelCause = ""
    var signatureImageURL = ""
    var signatureImage : UIImage?
    //---------
    //views
    let bottomView: UIView = {
        let bv = UIView()
        bv.layer.shadowColor = UIColor(ciColor: .black).cgColor
        bv.layer.shadowOffset = CGSize(width: 0, height: 1);
        bv.layer.shadowOpacity = 1;
        bv.layer.shadowRadius = 1.0;
        bv.clipsToBounds = false;
        bv.backgroundColor =  UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        return bv
    }()
 //-----------------
    
 //-----------------
    lazy var autreTextView: UITextView = {
        let tv = UITextView()
        tv.alpha = 0
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        tv.backgroundColor = UIColor(white: 0, alpha: 0.1)
        tv.textColor = .darkGray
        return tv
    }()
   
    let causeLabel11 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Client absent"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    
    let causeImage11 : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ClientAbsent")
        imageView.alpha = 0
        return imageView
    }()
    
    let causeLabel12 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "J'ai eu une panne"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeImage12 : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Panne")
        imageView.alpha = 0
        return imageView
    }()
    let causeLabel21 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Marchandise non adaptée"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeImage21 : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NotAdapted")
        imageView.alpha = 0
        return imageView
    }()
    let causeLabel22 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "J'ai eu un accident"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeImage22 : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Accident")
        imageView.alpha = 0
        return imageView
    }()
    let causeLabel3 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Rue inaccessible"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    let causeImage3 : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Inaccessible")
        imageView.alpha = 0
        return imageView
    }()
    let causeLabel4 : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Autre"
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
   
    
    let radioButton11 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1) )
        return rb
    }()
    let radioButton12 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton21 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton22 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton3 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    let radioButton4 : LTHRadioButton = {
        let rb = LTHRadioButton(diameter: 20, selectedColor: UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1))
        return rb
    }()
    //---------------------------------------------------------------------
    // Assigned Stackview
    lazy var stackViewAssigned: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [GoButton, BackButton1])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    let GoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goButton), for: .touchUpInside)
        return button
    }()
    let BackButton1 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let wazeIconAssigned : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wazeIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Go: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Go, BackButton4])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Go: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Go, NonButton_Go])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Go : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "GO"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Go : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "GO"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton4 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_Go : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Confirmer votre choix?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    //---------------------------------------------------------------------
    // Accepted Stackview
    lazy var stackViewAccepted: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewArrivedOrCancel, BackButton2])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewArrivedOrCancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ArrivedButton, CancelButton_Arrived])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let ArrivedButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Arrivé", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(arrivedButton), for: .touchUpInside)
        return button
    }()
    let CancelButton_Arrived : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Annuler", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButton_Arrived), for: .touchUpInside)
        return button
    }()
    let BackButton2 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let wazeIconAccepted : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wazeIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Arrived: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Arrived, BackButton7])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Arrived: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Arrived, NonButton_Arrived])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Arrived : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "ARRIVED"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Arrived : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "ARRIVED"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton7 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_Arrived : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Êtes-vous sûr?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    //---------------------------------------------------------------------
    // Livraison Stackview
    lazy var stackViewDelivering: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ArrivedToDeliveryDestinationButton, BackButton8])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    let ArrivedToDeliveryDestinationButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Je suis arrivé", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(arrivedToDeliveryDestinationButton), for: .touchUpInside)
        return button
    }()
    let BackButton8 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let wazeIconDelivering : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wazeIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Delivering: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Delivering, BackButton9])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Delivering: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Delivering, NonButton_Delivering])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Delivering : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "DELIVERING"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Delivering : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "DELIVERING"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton9 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_Delivering : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Êtes-vous sûr?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    //---------------------------------------------------------------------
    lazy var stackViewPickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewConfirmOrCancel, BackButton6])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewConfirmOrCancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ConfirmButton, CancelButton_Pickup])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let ConfirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirmer", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.alpha = 0.5
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmButton), for: .touchUpInside)
        return button
    }()
    let CancelButton_Pickup : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Annuler", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButton_Pickup), for: .touchUpInside)
        return button
    }()
    let BackButton6 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let cameraIconPickup : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cameraIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let imagesIconPickup : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "imagesIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let wazeIconPickup : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wazeIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Pickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Pickup, BackButton3])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Pickup: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Pickup, NonButton_Pickup])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Pickup : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "PICKUP"
        button.setTitle("Oui", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Pickup : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "PICKUP"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton3 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_Pickup : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Êtes-vous sûr?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    
    //---------------------------------------------------------------------
    lazy var stackViewDeposing: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [FinishButton, BackButton10])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
   
    let FinishButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terminer", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.alpha = 0.5
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(finishButton), for: .touchUpInside)
        return button
    }()
   
    let BackButton10 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let cameraIconDeposing : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cameraIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let imagesIconDeposing : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "imagesIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let wazeIconDeposing : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wazeIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_End: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_End, BackButton11])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_End: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_End, NonButton_End])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_End : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "END"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_End : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "END"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton11 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let confirmationLabel_End : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Terminer la course?"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))!
        return label
    }()
    //---------------------------------------------------------------------
    lazy var stackViewOuiNonBack_Cancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stackViewOuiNon_Cancel, BackButton5])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    lazy var stackViewOuiNon_Cancel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [OuiButton_Cancel, NonButton_Cancel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let OuiButton_Cancel : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = true
        button.phase = "CANCEL"
        button.setTitle("Oui", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (40/255), green: 167/255, blue: 69/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let NonButton_Cancel : OuiNonButton = {
        let button = OuiNonButton(type: .system)
        button.yes = false
        button.phase = "CANCEL"
        button.setTitle("Non", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (205/255), green: 102/255, blue: 102/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(OuiNonHandler(sender:)), for: .touchUpInside)
        return button
    }()
    let BackButton5 : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retour", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
        return button
    }()
    let signatureClient : UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.backgroundColor = .clear
        label.text = "Signature client"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        return label
    }()
     //---------------------------------------------------------------------
    lazy var stackViewType: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [Habitat, Magasin, Bureau])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        return sv
    }()
    let Habitat : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Habitat", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(11))!
        button.layer.cornerRadius = 5
        button.tag = 1
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    let Magasin : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Magasin", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 5
        button.tag = 2
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    let Bureau : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bureau", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        button.layer.cornerRadius = 5
        button.tag = 3
        button.addTarget(self, action: #selector(typePickButton(sender:)), for: .touchUpInside)
        return button
    }()
    //---------------------------------------------------------------------
//    let activityIndicator: UIView = {
//       let view = UIView()
//        view.backgroundColor = .red
//        view.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        view.alpha = 0
//       return view
//    }()
    
    //---------------------------------------------------------------------
    @objc func openWaze(sender: wazeTapGesture){
            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                // Waze is installed. Launch Waze and start navigation
                let urlStr: String = "waze://?ll=\(sender.latitude),\(sender.longitude)&navigate=yes"
                UIApplication.shared.openURL(URL(string: urlStr)!)
            }
            else {
                // Waze is not installed. Launch AppStore to install Waze app
                UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
            }
    }
    //---------------------------------------------------------------------
    @objc func showImages(sender: MyTapGesture){
      print("show images!")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : CollectionViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "colisImages") as! CollectionViewController
        destViewController.toggleSideMenuView()
        destViewController.codeCourse = self.codeCourse
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    
    fileprivate func storeImage(_ image: UIImage?,type: String, completion: (() -> Void)? = nil) {
        print("1")
        if let data = image?.pngData(){
        print("2")
        let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
            RealmManager.sharedInstance.addColisImagesData(course, data: data, type: type)
        }
        print("3")
        self.toggleSideMenuView()
        self.sideMenuController()?.setContentViewController(contentViewController: self)

    }
    
    @objc func showCamera(sender: MyTapGesture){
      print("show camera!")
        let camera = DKCamera()
        camera.didCancel = { () in
            print("didCancel")
            self.toggleSideMenuView()
            self.sideMenuController()?.setContentViewController(contentViewController: self)
        }
        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
            print("didFinishCapturingImage")
            self.storeImage(image, type: sender.param)
        }
        
        camera.toggleSideMenuView()
        sideMenuController()?.setContentViewController(contentViewController: camera)
    }

    //---------------------------------------------------------------------
    @objc func typePickButton(sender: UIButton){
        switch sender.tag{
        case 1:
          self.selectedType = "Habitat"
          self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        case 2:
          self.selectedType = "Magasin"
          self.Habitat.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
        case 3:
          self.selectedType = "Bureau"
          self.Habitat.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
          self.Bureau.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
        default:
            break
        }
    }
    //---------------------------------------------------------------------
    @objc func arrivedButton(){
        wazeIconAccepted.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            self.bottomViewHeightConstraint.constant = self.confirmationHeight
                            self.view.layoutIfNeeded()
                        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.stackViewAccepted.removeFromSuperview()
            //**************stackViewOuiNonBack_Arrived**************
            self.bottomView.addSubview(self.stackViewOuiNonBack_Arrived)
            //Layout Setup
            self.stackViewOuiNonBack_Arrived.translatesAutoresizingMaskIntoConstraints = false
            self.stackViewOuiNonBack_Arrived.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
            self.stackViewOuiNonBack_Arrived.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.stackViewOuiNonBack_Arrived.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            self.stackViewOuiNonBack_Arrived.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
            //**************confirmationLabel_Arrived**************
            self.view.addSubview(self.confirmationLabel_Arrived)
            //Layout Setup
            self.confirmationLabel_Arrived.translatesAutoresizingMaskIntoConstraints = false
            self.confirmationLabel_Arrived.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_Arrived.topAnchor, constant: -10).isActive = true
            self.confirmationLabel_Arrived.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
        }
       
    }
   //---------------------------------------------------------------------
        @objc func arrivedToDeliveryDestinationButton(){
            wazeIconDelivering.removeFromSuperview()
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bottomViewHeightConstraint.constant = self.confirmationHeight
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewDelivering.removeFromSuperview()
                self.bottomView.addSubview(self.stackViewOuiNonBack_Delivering)
                //Layout Setup
                self.stackViewOuiNonBack_Delivering.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewOuiNonBack_Delivering.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewOuiNonBack_Delivering.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewOuiNonBack_Delivering.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewOuiNonBack_Delivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************confirmationLabel_Go**************
                self.view.addSubview(self.confirmationLabel_Delivering)
                //Layout Setup
                self.confirmationLabel_Delivering.translatesAutoresizingMaskIntoConstraints = false
                self.confirmationLabel_Delivering.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_Delivering.topAnchor, constant: -10).isActive = true
                self.confirmationLabel_Delivering.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
            }
    }
//---------------------------------------------------------------------

    @objc func finishButton(){
        if (self.FinishButton.alpha != 1){
            print("Signature arrivée manquante")
        } else {
        signatureViewController.view.removeFromSuperview()
        signatureClient.removeFromSuperview()
        self.cameraIconDeposing.removeFromSuperview()
        self.imagesIconDeposing.removeFromSuperview()
        self.wazeIconDeposing.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.confirmationHeight
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.stackViewDeposing.removeFromSuperview()
            //**************stackViewOuiNonBack_End**************
            self.bottomView.addSubview(self.stackViewOuiNonBack_End)
            //Layout Setup
            self.stackViewOuiNonBack_End.translatesAutoresizingMaskIntoConstraints = false
            self.stackViewOuiNonBack_End.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
            self.stackViewOuiNonBack_End.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.stackViewOuiNonBack_End.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            self.stackViewOuiNonBack_End.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
            //**************confirmationLabel_End**************
            self.view.addSubview(self.confirmationLabel_End)
            //Layout Setup
            self.confirmationLabel_End.translatesAutoresizingMaskIntoConstraints = false
            self.confirmationLabel_End.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_End.topAnchor, constant: -10).isActive = true
            self.confirmationLabel_End.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
        }
      }
    }
    @objc func confirmButton(){
        if (self.ConfirmButton.alpha != 1){
            print("Signature départ manquante")
        } else {
            cameraIconPickup.removeFromSuperview()
            imagesIconPickup.removeFromSuperview()
            wazeIconPickup.removeFromSuperview()
            signatureViewController.view.removeFromSuperview()
            signatureClient.removeFromSuperview()
            stackViewType.removeFromSuperview()
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bottomViewHeightConstraint.constant = self.confirmationHeight
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewPickup.removeFromSuperview()
                //**************stackViewOuiNonBack_Pickup**************
                self.bottomView.addSubview(self.stackViewOuiNonBack_Pickup)
                //Layout Setup
                self.stackViewOuiNonBack_Pickup.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewOuiNonBack_Pickup.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewOuiNonBack_Pickup.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewOuiNonBack_Pickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewOuiNonBack_Pickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************confirmationLabel_Pickup**************
                self.view.addSubview(self.confirmationLabel_Pickup)
                //Layout Setup
                self.confirmationLabel_Pickup.translatesAutoresizingMaskIntoConstraints = false
                self.confirmationLabel_Pickup.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_Pickup.topAnchor, constant: -10).isActive = true
                self.confirmationLabel_Pickup.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
            }
        }
    }
    //------------------
    @objc func labelTaped(sender : MyCauseLabelTap) {
        switch sender.param {
        case "11":
            radioButton11.select()
        case "12":
            radioButton12.select()
        case "21":
            radioButton21.select()
        case "22":
            radioButton22.select()
        case "3":
            radioButton3.select()
        case "4":
            radioButton4.select()
        default:
            break
        }
    }
    fileprivate func GetCancelCause1() {
        radioButton11.select()
        //**************stackViewOuiNonBack_Cancel**************
        bottomView.addSubview(stackViewOuiNonBack_Cancel)
        //Layout Setup
        stackViewOuiNonBack_Cancel.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Cancel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Cancel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackViewOuiNonBack_Cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Cancel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //--------
        bottomView.addSubview(radioButton11)
        bottomView.addSubview(radioButton21)
        bottomView.addSubview(radioButton3)
        bottomView.addSubview(radioButton4)
        //Layout Setup
        radioButton11.translatesAutoresizingMaskIntoConstraints = false
        radioButton21.translatesAutoresizingMaskIntoConstraints = false
        radioButton3.translatesAutoresizingMaskIntoConstraints = false
        radioButton4.translatesAutoresizingMaskIntoConstraints = false
        radioButton11.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton21.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton3.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton4.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton11.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        radioButton21.topAnchor.constraint(equalTo: radioButton11.bottomAnchor, constant: 20).isActive = true
        radioButton3.topAnchor.constraint(equalTo: radioButton21.bottomAnchor, constant: 20).isActive = true
        radioButton4.topAnchor.constraint(equalTo: radioButton3.bottomAnchor, constant: 20).isActive = true
        radioButton11.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton21.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton11.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton21.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //--------------
        bottomView.addSubview(causeLabel11)
        bottomView.addSubview(causeLabel21)
        bottomView.addSubview(causeLabel3)
        bottomView.addSubview(causeLabel4)
        causeLabel11.isUserInteractionEnabled = true
        causeLabel21.isUserInteractionEnabled = true
        causeLabel3.isUserInteractionEnabled = true
        causeLabel4.isUserInteractionEnabled = true
        let tap11: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap21: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap3: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap4: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        tap11.param = "11"
        tap21.param = "21"
        tap3.param = "3"
        tap4.param = "4"
        causeLabel11.addGestureRecognizer(tap11)
        causeLabel21.addGestureRecognizer(tap21)
        causeLabel3.addGestureRecognizer(tap3)
        causeLabel4.addGestureRecognizer(tap4)
        //Layout Setup
        causeLabel11.translatesAutoresizingMaskIntoConstraints = false
        causeLabel21.translatesAutoresizingMaskIntoConstraints = false
        causeLabel3.translatesAutoresizingMaskIntoConstraints = false
        causeLabel4.translatesAutoresizingMaskIntoConstraints = false
        causeLabel11.leadingAnchor.constraint(equalTo: radioButton11.trailingAnchor, constant: 10).isActive = true
        causeLabel21.leadingAnchor.constraint(equalTo: radioButton21.trailingAnchor, constant: 10).isActive = true
        causeLabel3.leadingAnchor.constraint(equalTo: radioButton3.trailingAnchor, constant: 10).isActive = true
        causeLabel4.leadingAnchor.constraint(equalTo: radioButton4.trailingAnchor, constant: 10).isActive = true
        causeLabel11.centerYAnchor.constraint(equalTo: radioButton11.centerYAnchor).isActive = true
        causeLabel21.centerYAnchor.constraint(equalTo: radioButton21.centerYAnchor).isActive = true
        causeLabel3.centerYAnchor.constraint(equalTo: radioButton3.centerYAnchor).isActive = true
        causeLabel4.centerYAnchor.constraint(equalTo: radioButton4.centerYAnchor).isActive = true
        //****************************
        bottomView.addSubview(autreTextView)
        bottomView.addSubview(causeImage11)
        bottomView.addSubview(causeImage21)
        bottomView.addSubview(causeImage3)
        //Layout Setup
        autreTextView.translatesAutoresizingMaskIntoConstraints = false
        autreTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        autreTextView.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        autreTextView.leadingAnchor.constraint(equalTo: causeLabel11.trailingAnchor, constant: 10).isActive = true
        autreTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //------
        causeImage11.translatesAutoresizingMaskIntoConstraints = false
        causeImage11.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20).isActive = true
        causeImage11.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage11.leadingAnchor.constraint(equalTo: causeLabel11.trailingAnchor, constant: 10).isActive = true
        causeImage11.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        //------
        causeImage21.translatesAutoresizingMaskIntoConstraints = false
        causeImage21.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30).isActive = true
        causeImage21.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage21.leadingAnchor.constraint(equalTo: causeLabel11.trailingAnchor, constant: 30).isActive = true
        causeImage21.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        //------
        causeImage3.translatesAutoresizingMaskIntoConstraints = false
        causeImage3.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 40).isActive = true
        causeImage3.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage3.leadingAnchor.constraint(equalTo: causeLabel11.trailingAnchor, constant: 30).isActive = true
        causeImage3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    fileprivate func GetCancelCause2() {
        radioButton12.select()
        //**************stackViewOuiNonBack_Cancel**************
        bottomView.addSubview(stackViewOuiNonBack_Cancel)
        //Layout Setup
        stackViewOuiNonBack_Cancel.translatesAutoresizingMaskIntoConstraints = false
        stackViewOuiNonBack_Cancel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
        stackViewOuiNonBack_Cancel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackViewOuiNonBack_Cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackViewOuiNonBack_Cancel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //-----------
        bottomView.addSubview(radioButton12)
        bottomView.addSubview(radioButton22)
        bottomView.addSubview(radioButton3)
        bottomView.addSubview(radioButton4)
        //Layout Setup
        radioButton12.translatesAutoresizingMaskIntoConstraints = false
        radioButton22.translatesAutoresizingMaskIntoConstraints = false
        radioButton3.translatesAutoresizingMaskIntoConstraints = false
        radioButton4.translatesAutoresizingMaskIntoConstraints = false
        radioButton12.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton22.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton3.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton4.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        radioButton12.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        radioButton22.topAnchor.constraint(equalTo: radioButton12.bottomAnchor, constant: 20).isActive = true
        radioButton3.topAnchor.constraint(equalTo: radioButton22.bottomAnchor, constant: 20).isActive = true
        radioButton4.topAnchor.constraint(equalTo: radioButton3.bottomAnchor, constant: 20).isActive = true
        radioButton12.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton22.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton12.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton22.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //-----------
        bottomView.addSubview(causeLabel12)
        bottomView.addSubview(causeLabel22)
        bottomView.addSubview(causeLabel3)
        bottomView.addSubview(causeLabel4)
        causeLabel12.isUserInteractionEnabled = true
        causeLabel22.isUserInteractionEnabled = true
        causeLabel3.isUserInteractionEnabled = true
        causeLabel4.isUserInteractionEnabled = true
        let tap12: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap22: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap3: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        let tap4: MyCauseLabelTap = MyCauseLabelTap(target: self, action: #selector(labelTaped(sender:)))
        tap12.param = "12"
        tap22.param = "22"
        tap3.param = "3"
        tap4.param = "4"
        causeLabel12.addGestureRecognizer(tap12)
        causeLabel22.addGestureRecognizer(tap22)
        causeLabel3.addGestureRecognizer(tap3)
        causeLabel4.addGestureRecognizer(tap4)
        //Layout Setup
        causeLabel12.translatesAutoresizingMaskIntoConstraints = false
        causeLabel22.translatesAutoresizingMaskIntoConstraints = false
        causeLabel3.translatesAutoresizingMaskIntoConstraints = false
        causeLabel4.translatesAutoresizingMaskIntoConstraints = false
        causeLabel12.leadingAnchor.constraint(equalTo: radioButton12.trailingAnchor, constant: 10).isActive = true
        causeLabel22.leadingAnchor.constraint(equalTo: radioButton22.trailingAnchor, constant: 10).isActive = true
        causeLabel3.leadingAnchor.constraint(equalTo: radioButton3.trailingAnchor, constant: 10).isActive = true
        causeLabel4.leadingAnchor.constraint(equalTo: radioButton4.trailingAnchor, constant: 10).isActive = true
        causeLabel12.centerYAnchor.constraint(equalTo: radioButton12.centerYAnchor).isActive = true
        causeLabel22.centerYAnchor.constraint(equalTo: radioButton22.centerYAnchor).isActive = true
        causeLabel3.centerYAnchor.constraint(equalTo: radioButton3.centerYAnchor).isActive = true
        causeLabel4.centerYAnchor.constraint(equalTo: radioButton4.centerYAnchor).isActive = true
        //********************************
        bottomView.addSubview(autreTextView)
        bottomView.addSubview(causeImage12)
        bottomView.addSubview(causeImage22)
        bottomView.addSubview(causeImage3)
        //Layout Setup
        autreTextView.translatesAutoresizingMaskIntoConstraints = false
        autreTextView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        autreTextView.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        autreTextView.leadingAnchor.constraint(equalTo: causeLabel12.trailingAnchor, constant: 10).isActive = true
        autreTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //----------
        causeImage12.translatesAutoresizingMaskIntoConstraints = false
        causeImage12.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20).isActive = true
        causeImage12.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage12.leadingAnchor.constraint(equalTo: causeLabel12.trailingAnchor, constant: 10).isActive = true
        causeImage12.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        //----------
        causeImage22.translatesAutoresizingMaskIntoConstraints = false
        causeImage22.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30).isActive = true
        causeImage22.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage22.leadingAnchor.constraint(equalTo: causeLabel12.trailingAnchor, constant: 10).isActive = true
        causeImage22.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        //----------
        causeImage3.translatesAutoresizingMaskIntoConstraints = false
        causeImage3.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 40).isActive = true
        causeImage3.bottomAnchor.constraint(equalTo: radioButton4.bottomAnchor, constant: 0).isActive = true
        causeImage3.leadingAnchor.constraint(equalTo: causeLabel12.trailingAnchor, constant: 10).isActive = true
        causeImage3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    
    @objc func cancelButton_Arrived(){
        wazeIconAccepted.removeFromSuperview()
        radioButton12.select()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.highHeight
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.stackViewAccepted.removeFromSuperview()
            self.GetCancelCause2()
        }
        self.NonButton_Cancel.phase = "CANCEL_FROM_ACCEPTED"
        self.OuiButton_Cancel.phase = "CANCEL_FROM_ACCEPTED"
    }
    @objc func cancelButton_Pickup(){
        cameraIconPickup.removeFromSuperview()
        imagesIconPickup.removeFromSuperview()
        wazeIconPickup.removeFromSuperview()
        radioButton11.select()
        stackViewType.removeFromSuperview()
        signatureViewController.view.removeFromSuperview()
        signatureClient.removeFromSuperview()
        stackViewPickup.removeFromSuperview()
        GetCancelCause1()
        NonButton_Cancel.phase = "CANCEL_FROM_PICKUP"
        OuiButton_Cancel.phase = "CANCEL_FROM_PICKUP"

    }
    @objc func goButton(){
        wazeIconAssigned.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.confirmationHeight
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.stackViewAssigned.removeFromSuperview()
            self.bottomView.addSubview(self.stackViewOuiNonBack_Go)
            //Layout Setup
            self.stackViewOuiNonBack_Go.translatesAutoresizingMaskIntoConstraints = false
            self.stackViewOuiNonBack_Go.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
            self.stackViewOuiNonBack_Go.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.stackViewOuiNonBack_Go.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            self.stackViewOuiNonBack_Go.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
            //**************confirmationLabel_Go**************
            self.view.addSubview(self.confirmationLabel_Go)
            //Layout Setup
            self.confirmationLabel_Go.translatesAutoresizingMaskIntoConstraints = false
            self.confirmationLabel_Go.bottomAnchor.constraint(equalTo: self.stackViewOuiNonBack_Go.topAnchor, constant: -10).isActive = true
            self.confirmationLabel_Go.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
      }
    }
    fileprivate func AcceptCourse(completion:(()->())?) {
        
        let myDictOfDict:[String:Any] = [
            "codeCourse" : codeCourse,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : codeCorner,
            "courseSource" : courseSource,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        
        SocketIOManager.sharedInstance.acceptCourse(dict: myDictOfDict)
        completion?()
    }
    
    fileprivate func PickUpCourse(completion:(()->())?) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : codeCourse,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : codeCorner,
            "courseSource" : courseSource,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        
        SocketIOManager.sharedInstance.pickUpCourse(dict: myDictOfDict)
        completion?()
    }
    fileprivate func DeliveringCourse(completion:(()->())?) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : codeCourse,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : codeCorner,
            "courseSource" : courseSource,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        
        SocketIOManager.sharedInstance.deliveringCourse(dict: myDictOfDict)
        completion?()
    }
    fileprivate func DeposingCourse(completion:(()->())?) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : codeCourse,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "codeCorner" : codeCorner,
            "courseSource" : courseSource,
            "vehicule" : SessionManager.currentSession.getCurrentVehiculeDictionary()!
        ]
        
        SocketIOManager.sharedInstance.deposingCourse(dict: myDictOfDict)
        completion?()
    }
   
    fileprivate func EndCourse(completion:(()->())?) {
        let myDictOfDict:[String:Any] = [
            "codeCourse" : codeCourse,
            "idChauffeur" : SessionManager.currentSession.currentResponse!.authToken!.chauffeur!.id.value!,
            "km": 1,
            "duration" : 1,
            "codeCorner" : codeCorner,
            "courseSource" : courseSource,
            "isLastCourse" : isLastCourse()
        ]
        
        SocketIOManager.sharedInstance.endCourse(dict: myDictOfDict)
        completion?()
    }
    fileprivate func isLastCourse() -> Int {
        if (SessionManager.currentSession.acceptedCourses.count == 1) {
            return 1
        } else {
            return 0
        }
    }
    @objc func OuiNonHandler(sender: OuiNonButton){
        switch sender.phase{
        case "GO":
            if (sender.yes){
                wazeIconAssigned.removeFromSuperview()
                //----------
                AcceptCourse(){
                print("Course: \(self.codeCourse) was accepted")
                let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
                RealmManager.sharedInstance.acceptCourse(course)
                //----------
                self.confirmationLabel_Go.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.lowHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stackViewOuiNonBack_Go.removeFromSuperview()
                    //**************stackViewAccepted**************
                    self.bottomView.addSubview(self.stackViewAccepted)
                    //Layout Setup 
                    self.stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
                    self.stackViewAccepted.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                    self.stackViewAccepted.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    self.stackViewAccepted.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                    self.stackViewAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                    //**************wazeIcon**************
                    self.bottomView.addSubview(self.wazeIconAccepted)
                    self.wazeIconAccepted.isUserInteractionEnabled = true
                    let wazeTapAccepted = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                    wazeTapAccepted.latitude = self.latitudeArrivee
                    wazeTapAccepted.longitude = self.longitudeArrivee
                    self.wazeIconAccepted.addGestureRecognizer(wazeTapAccepted)
                    //Layout Setup
                    self.wazeIconAccepted.translatesAutoresizingMaskIntoConstraints = false
                    self.wazeIconAccepted.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.wazeIconAccepted.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconAccepted.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                }
            }
            }else{
                confirmationLabel_Go.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.lowHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewOuiNonBack_Go.removeFromSuperview()
                //**************stackViewAssigned**************
                self.bottomView.addSubview(self.stackViewAssigned)
                //Layout Setup stackViewAssigned
                self.stackViewAssigned.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewAssigned.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewAssigned.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewAssigned.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewAssigned.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************wazeIcon**************
                self.bottomView.addSubview(self.wazeIconAssigned)
                self.wazeIconAssigned.isUserInteractionEnabled = true
                let wazeTapAssigned = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                wazeTapAssigned.latitude = self.latitudeArrivee
                wazeTapAssigned.longitude = self.longitudeArrivee
                self.wazeIconAssigned.addGestureRecognizer(wazeTapAssigned)
                //Layout Setup
                self.wazeIconAssigned.translatesAutoresizingMaskIntoConstraints = false
                self.wazeIconAssigned.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.wazeIconAssigned.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconAssigned.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconAssigned.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
              }
            }
        case "ARRIVED":
            if (sender.yes){
                wazeIconAccepted.removeFromSuperview()
                PickUpCourse(){
                    print("Course: \(self.codeCourse) is being picked up")
                    let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
                    RealmManager.sharedInstance.pickupCourse(course)
                    
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.highHeight
                    self.view.layoutIfNeeded()
                })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.stackViewOuiNonBack_Arrived.removeFromSuperview()
                        self.confirmationLabel_Arrived.removeFromSuperview()
                        //**************stackViewPickup**************
                        self.bottomView.addSubview(self.stackViewPickup)
                        //Layout Setup
                        self.stackViewPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.stackViewPickup.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                        self.stackViewPickup.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        self.stackViewPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.stackViewPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //************stackViewType***********
                        self.view.addSubview(self.stackViewType)
                        //Layout Setup
                        self.stackViewType.translatesAutoresizingMaskIntoConstraints = false
                        self.stackViewType.heightAnchor.constraint(equalToConstant: 60)
                        self.stackViewType.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 35).isActive = true
                        self.stackViewType.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.stackViewType.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //************signatureViewController.view***********
                        self.view.addSubview(self.signatureViewController.view)
                        //Layout Setup
                        self.signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                        self.signatureViewController.view.bottomAnchor.constraint(equalTo: self.stackViewPickup.topAnchor, constant: -15).isActive = true
                        self.signatureViewController.view.topAnchor.constraint(equalTo: self.stackViewType.bottomAnchor, constant: 10).isActive = true
                        self.signatureViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.signatureViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //**************signatureView**************
                        self.signatureViewController.delegate = self
                        self.addChild(self.signatureViewController)
                        self.signatureViewController.didMove(toParent: self)
                        self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
                        //************signatureClient***********
                        self.view.addSubview(self.signatureClient)
                        //Layout Setup
                        self.signatureClient.translatesAutoresizingMaskIntoConstraints = false
                        self.signatureClient.topAnchor.constraint(equalTo: self.signatureViewController.view.topAnchor, constant: 0).isActive = true
                        self.signatureClient.centerXAnchor.constraint(equalTo: self.signatureViewController.view.centerXAnchor).isActive = true
                        self.signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
                        //**************cameraIcon**************
                        self.view.addSubview(self.cameraIconPickup)
                        self.cameraIconPickup.isUserInteractionEnabled = true
                        let tap3 = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
                        tap3.param = "depart"
                        self.cameraIconPickup.addGestureRecognizer(tap3)
                        //Layout Setup
                        self.cameraIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.cameraIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.cameraIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.cameraIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.cameraIconPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                        //**************imagesIcon**************
                        self.bottomView.addSubview(self.imagesIconPickup)
                        self.imagesIconPickup.isUserInteractionEnabled = true
                        let tap4 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
                        tap4.param = "depart"
                        self.imagesIconPickup.addGestureRecognizer(tap4)
                        //Layout Setup
                        self.imagesIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.imagesIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.imagesIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.imagesIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.imagesIconPickup.leadingAnchor.constraint(equalTo: self.cameraIconPickup.trailingAnchor, constant: 20).isActive = true
                        //**************wazeIcon**************
                        self.bottomView.addSubview(self.wazeIconPickup)
                        self.wazeIconPickup.isUserInteractionEnabled = true
                        let wazeTapPickup = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                        wazeTapPickup.latitude = self.latitudeArrivee
                        wazeTapPickup.longitude = self.longitudeArrivee
                        self.wazeIconDelivering.addGestureRecognizer(wazeTapPickup)
                        //Layout Setup
                        self.wazeIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.wazeIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.wazeIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.wazeIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.wazeIconPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                    }
                }
            }else{
                confirmationLabel_Arrived.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.lowHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewOuiNonBack_Arrived.removeFromSuperview()
                //**************stackViewAccepted**************
                self.bottomView.addSubview(self.stackViewAccepted)
                //Layout Setup stackViewAccepted
                self.stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewAccepted.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewAccepted.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewAccepted.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************wazeIcon**************
                self.bottomView.addSubview(self.wazeIconAccepted)
                self.wazeIconAccepted.isUserInteractionEnabled = true
                let wazeTapAccepted = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                wazeTapAccepted.latitude = self.latitudeArrivee
                wazeTapAccepted.longitude = self.longitudeArrivee
                self.wazeIconAssigned.addGestureRecognizer(wazeTapAccepted)
                //Layout Setup
                self.wazeIconAccepted.translatesAutoresizingMaskIntoConstraints = false
                self.wazeIconAccepted.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.wazeIconAccepted.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconAccepted.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                }
            }
        case "PICKUP":
            if (sender.yes){
                 DeliveringCourse(){
                print("Course: \(self.codeCourse) is being delivered")
                let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
                    let imagesDepart = Array(course.colisImagesDataDepart).map{
                        UIImage(data: $0)!
                    }
                self.viewModel.uploadSignatureImage(image: self.signatureViewController.fullSignatureImage!, codeCourse: self.codeCourse, type: "depart", vc: self)
                self.viewModel.setPointEnlevement(codeCourse: self.codeCourse, pointEnlevement: self.selectedType)
                    self.viewModel.uploadPhotos(images: imagesDepart, codeCourse: self.codeCourse, type: "depart", vc: self)
                RealmManager.sharedInstance.setPointEnlevementCourse(course, type: self.selectedType)
                RealmManager.sharedInstance.addSignatureImageData(course, data: self.signatureViewController.fullSignatureImage!.pngData()!, type: "depart")
                RealmManager.sharedInstance.deliveringCourse(course)
//                RealmManager.sharedInstance.setSignatureDepart(course, imageURL: self.signatureImageURL)

                   
             
                self.confirmationLabel_Pickup.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.lowHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.stackViewOuiNonBack_Pickup.removeFromSuperview()
                //**************stackViewDelivering**************
                self.bottomView.addSubview(self.stackViewDelivering)
                //Layout Setup stackViewDelivering
                self.stackViewDelivering.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewDelivering.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewDelivering.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewDelivering.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewDelivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************wazeIcon**************
                self.bottomView.addSubview(self.wazeIconDelivering)
                self.wazeIconDelivering.isUserInteractionEnabled = true
                let wazeTapDelivering = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                wazeTapDelivering.latitude = self.latitudeArrivee
                wazeTapDelivering.longitude = self.longitudeArrivee
                self.wazeIconDelivering.addGestureRecognizer(wazeTapDelivering)
                //Layout Setup
                self.wazeIconDelivering.translatesAutoresizingMaskIntoConstraints = false
                self.wazeIconDelivering.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.wazeIconDelivering.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconDelivering.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconDelivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                   }
                }
            }else{
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.highHeight
                    self.view.layoutIfNeeded()
                })
                    self.selectedType = "Habitat"
                    self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
                    self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                    self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                    self.signatureViewController.reset()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.stackViewOuiNonBack_Pickup.removeFromSuperview()
                        self.confirmationLabel_Pickup.removeFromSuperview()

                        //**************stackViewPickup**************
                        self.bottomView.addSubview(self.stackViewPickup)
                        //Layout Setup
                        self.stackViewPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.stackViewPickup.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                        self.stackViewPickup.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        self.stackViewPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.stackViewPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //************stackViewType***********
                        self.view.addSubview(self.stackViewType)
                        //Layout Setup
                        self.stackViewType.translatesAutoresizingMaskIntoConstraints = false
                        self.stackViewType.heightAnchor.constraint(equalToConstant: 60)
                        self.stackViewType.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 35).isActive = true
                        self.stackViewType.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.stackViewType.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //************signatureViewController.view***********
                        self.view.addSubview(self.signatureViewController.view)
                        //Layout Setup
                        self.signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                        self.signatureViewController.view.bottomAnchor.constraint(equalTo: self.stackViewPickup.topAnchor, constant: -15).isActive = true
                        self.signatureViewController.view.topAnchor.constraint(equalTo: self.stackViewType.bottomAnchor, constant: 10).isActive = true
                        self.signatureViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                        self.signatureViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                        //**************signatureView**************
                        self.signatureViewController.delegate = self
                        self.addChild(self.signatureViewController)
                        self.signatureViewController.didMove(toParent: self)
                        self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
                        //************signatureClient***********
                        self.view.addSubview(self.signatureClient)
                        //Layout Setup
                        self.signatureClient.translatesAutoresizingMaskIntoConstraints = false
                        self.signatureClient.topAnchor.constraint(equalTo: self.signatureViewController.view.topAnchor, constant: 0).isActive = true
                        self.signatureClient.centerXAnchor.constraint(equalTo: self.signatureViewController.view.centerXAnchor).isActive = true
                        self.signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
                        //**************cameraIcon**************
                        self.view.addSubview(self.cameraIconPickup)
                        self.cameraIconPickup.isUserInteractionEnabled = true
                        let tap3 = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
                        tap3.param = "depart"
                        self.cameraIconPickup.addGestureRecognizer(tap3)
                        //Layout Setup
                        self.cameraIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.cameraIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.cameraIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.cameraIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.cameraIconPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                        //**************imagesIcon**************
                        self.bottomView.addSubview(self.imagesIconPickup)
                        self.imagesIconPickup.isUserInteractionEnabled = true
                        let tap4 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
                        tap4.param = "depart"
                        self.imagesIconPickup.addGestureRecognizer(tap4)
                        //Layout Setup
                        self.imagesIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.imagesIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.imagesIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.imagesIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.imagesIconPickup.leadingAnchor.constraint(equalTo: self.cameraIconPickup.trailingAnchor, constant: 20).isActive = true
                        //**************wazeIcon**************
                        self.bottomView.addSubview(self.wazeIconPickup)
                        self.wazeIconPickup.isUserInteractionEnabled = true
                        let wazeTapPickup = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                        wazeTapPickup.latitude = self.latitudeArrivee
                        wazeTapPickup.longitude = self.longitudeArrivee
                        self.wazeIconPickup.addGestureRecognizer(wazeTapPickup)
                        //Layout Setup
                        self.wazeIconPickup.translatesAutoresizingMaskIntoConstraints = false
                        self.wazeIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                        self.wazeIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                        self.wazeIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        self.wazeIconPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                    }
            }
        case "CANCEL_FROM_ACCEPTED":
            if (sender.yes ){
                if (self.autreTextView.text != ""){
                    doCancel(cause: autreTextView.text)
                } else {
                    doCancel(cause: CancelCause)
                }
            }else{
                radioButton12.removeFromSuperview()
                radioButton22.removeFromSuperview()
                radioButton3.removeFromSuperview()
                radioButton4.removeFromSuperview()
                causeLabel12.removeFromSuperview()
                causeLabel22.removeFromSuperview()
                causeLabel3.removeFromSuperview()
                causeLabel4.removeFromSuperview()
                causeImage12.removeFromSuperview()
                causeImage22.removeFromSuperview()
                causeImage3.removeFromSuperview()
                autreTextView.removeFromSuperview()
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.bottomViewHeightConstraint.constant = self.lowHeight
                        self.view.layoutIfNeeded()
                    })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stackViewOuiNonBack_Cancel.removeFromSuperview()
                //**************stackViewAccepted**************
                    self.bottomView.addSubview(self.stackViewAccepted)
                //Layout Setup stackViewAccepted
                    self.stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
                    self.stackViewAccepted.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                    self.stackViewAccepted.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    self.stackViewAccepted.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                    self.stackViewAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                    //**************wazeIcon**************
                    self.bottomView.addSubview(self.wazeIconAccepted)
                    self.wazeIconAccepted.isUserInteractionEnabled = true
                    let wazeTapAccepted = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                    wazeTapAccepted.latitude = self.latitudeArrivee
                    wazeTapAccepted.longitude = self.longitudeArrivee
                    self.wazeIconAccepted.addGestureRecognizer(wazeTapAccepted)
                    //Layout Setup
                    self.wazeIconAccepted.translatesAutoresizingMaskIntoConstraints = false
                    self.wazeIconAccepted.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.wazeIconAccepted.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconAccepted.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
              }
            }
        case "CANCEL_FROM_PICKUP":
            if (sender.yes ){
                if (self.CancelCause == "La course a été annulée pour d'autres raisons"){
                    if(self.autreTextView.text != ""){
                        doCancel(cause: autreTextView.text)
                    } else {
                        doCancel(cause: CancelCause)
                    }
                }else{
                    doCancel(cause: CancelCause)
                }
            }else{
                        self.selectedType = "Habitat"
                        self.Habitat.backgroundColor = UIColor(displayP3Red: (25/255), green: 25/255, blue: 112/255, alpha: 1)
                        self.Magasin.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                        self.Bureau.backgroundColor = UIColor(displayP3Red: (100/255), green: 149/255, blue: 239/255, alpha: 1)
                        self.signatureViewController.reset()
                        stackViewOuiNonBack_Cancel.removeFromSuperview()
                        confirmationLabel_Arrived.removeFromSuperview()
                        radioButton11.removeFromSuperview()
                        radioButton21.removeFromSuperview()
                        radioButton3.removeFromSuperview()
                        radioButton4.removeFromSuperview()
                        causeLabel11.removeFromSuperview()
                        causeLabel21.removeFromSuperview()
                        causeLabel3.removeFromSuperview()
                        causeLabel4.removeFromSuperview()
                        causeImage11.removeFromSuperview()
                        causeImage21.removeFromSuperview()
                        causeImage3.removeFromSuperview()
                        autreTextView.removeFromSuperview()
                        //**************stackViewPickup**************
                        bottomView.addSubview(stackViewPickup)
                        //Layout Setup
                        stackViewPickup.translatesAutoresizingMaskIntoConstraints = false
                        stackViewPickup.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
                        stackViewPickup.heightAnchor.constraint(equalToConstant: 100).isActive = true
                        stackViewPickup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                        stackViewPickup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                        //************stackViewType***********
                        view.addSubview(stackViewType)
                        //Layout Setup
                        stackViewType.translatesAutoresizingMaskIntoConstraints = false
                        stackViewType.heightAnchor.constraint(equalToConstant: 60)
                        stackViewType.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 35).isActive = true
                        stackViewType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                        stackViewType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                        //************signatureViewController.view***********
                        view.addSubview(signatureViewController.view)
                        //Layout Setup
                        signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                        signatureViewController.view.bottomAnchor.constraint(equalTo: stackViewPickup.topAnchor, constant: -15).isActive = true
                        signatureViewController.view.topAnchor.constraint(equalTo: stackViewType.bottomAnchor, constant: 10).isActive = true
                        signatureViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                        signatureViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                        //**************signatureView**************
                        signatureViewController.delegate = self
                        addChild(signatureViewController)
                        signatureViewController.didMove(toParent: self)
                        signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
                        //************signatureClient***********
                        view.addSubview(signatureClient)
                        //Layout Setup
                        signatureClient.translatesAutoresizingMaskIntoConstraints = false
                        signatureClient.topAnchor.constraint(equalTo: signatureViewController.view.topAnchor, constant: 0).isActive = true
                        signatureClient.centerXAnchor.constraint(equalTo: signatureViewController.view.centerXAnchor).isActive = true
                        signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
                //**************cameraIcon**************
                self.view.addSubview(self.cameraIconPickup)
                self.cameraIconPickup.isUserInteractionEnabled = true
                let tap3 = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
                tap3.param = "depart"
                self.cameraIconPickup.addGestureRecognizer(tap3)
                //Layout Setup
                self.cameraIconPickup.translatesAutoresizingMaskIntoConstraints = false
                self.cameraIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.cameraIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.cameraIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.cameraIconPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                //**************imagesIcon**************
                self.bottomView.addSubview(self.imagesIconPickup)
                self.imagesIconPickup.isUserInteractionEnabled = true
                let tap4 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
                tap4.param = "depart"
                self.imagesIconPickup.addGestureRecognizer(tap4)
                //Layout Setup
                self.imagesIconPickup.translatesAutoresizingMaskIntoConstraints = false
                self.imagesIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.imagesIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.imagesIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.imagesIconPickup.leadingAnchor.constraint(equalTo: self.cameraIconPickup.trailingAnchor, constant: 20).isActive = true
                //**************wazeIcon**************
                self.bottomView.addSubview(self.wazeIconPickup)
                self.wazeIconPickup.isUserInteractionEnabled = true
                let wazeTapPickup = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                wazeTapPickup.latitude = self.latitudeArrivee
                wazeTapPickup.longitude = self.longitudeArrivee
                self.wazeIconPickup.addGestureRecognizer(wazeTapPickup)
                //Layout Setup
                self.wazeIconPickup.translatesAutoresizingMaskIntoConstraints = false
                self.wazeIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.wazeIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                
            }
        case "DELIVERING":
            if (sender.yes){
                wazeIconDelivering.removeFromSuperview()
                DeposingCourse(){
                self.signatureViewController.reset()
                print("Course: \(self.codeCourse) is being deposed")
                let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
                RealmManager.sharedInstance.deposingCourse(course)
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.highHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stackViewOuiNonBack_Delivering.removeFromSuperview()
                    self.confirmationLabel_Delivering.removeFromSuperview()
                //**************stackViewDeposing**************
                self.bottomView.addSubview(self.stackViewDeposing)
                //Layout Setup
                self.stackViewDeposing.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewDeposing.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                self.stackViewDeposing.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.stackViewDeposing.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.stackViewDeposing.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //************signatureViewController.view***********
                self.view.addSubview(self.signatureViewController.view)
                //Layout Setup
                self.signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                self.signatureViewController.view.bottomAnchor.constraint(equalTo: self.stackViewDeposing.topAnchor, constant: -15).isActive = true
                self.signatureViewController.view.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 35).isActive = true
                self.signatureViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                self.signatureViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                //**************signatureView**************
                self.signatureViewController.delegate = self
                self.addChild(self.signatureViewController)
                self.signatureViewController.didMove(toParent: self)
                self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
                //************signatureClient***********
                self.view.addSubview(self.signatureClient)
                //Layout Setup
                self.signatureClient.translatesAutoresizingMaskIntoConstraints = false
                self.signatureClient.topAnchor.constraint(equalTo: self.signatureViewController.view.topAnchor, constant: 0).isActive = true
                self.signatureClient.centerXAnchor.constraint(equalTo: self.signatureViewController.view.centerXAnchor).isActive = true
                self.signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
                //**************cameraIcon**************
                self.bottomView.addSubview(self.cameraIconDeposing)
                self.cameraIconDeposing.isUserInteractionEnabled = true
                let tap = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
                tap.param = "arrivee"
                self.cameraIconDeposing.addGestureRecognizer(tap)
                //Layout Setup
                self.cameraIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                self.cameraIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.cameraIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.cameraIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.cameraIconDeposing.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                //**************imagesIcon**************
                self.bottomView.addSubview(self.imagesIconDeposing)
                self.imagesIconDeposing.isUserInteractionEnabled = true
                let tap2 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
                tap.param = "arrivee"
                self.imagesIconDeposing.addGestureRecognizer(tap2)
                //Layout Setup
                self.imagesIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                self.imagesIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.imagesIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.imagesIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.imagesIconDeposing.leadingAnchor.constraint(equalTo: self.cameraIconDeposing.trailingAnchor, constant: 20).isActive = true
                //**************wazeIcon**************
                self.bottomView.addSubview(self.wazeIconDeposing)
                self.wazeIconDeposing.isUserInteractionEnabled = true
                let wazeTapDeposing = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                wazeTapDeposing.latitude = self.latitudeArrivee
                wazeTapDeposing.longitude = self.longitudeArrivee
                self.wazeIconDeposing.addGestureRecognizer(wazeTapDeposing)
                //Layout Setup
                self.wazeIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                self.wazeIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                self.wazeIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                self.wazeIconDeposing.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                    
                }
         }
            }else{
                confirmationLabel_Delivering.removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.lowHeight
                    self.view.layoutIfNeeded()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.stackViewOuiNonBack_Delivering.removeFromSuperview()
                    //**************stackViewAssigned**************
                    self.bottomView.addSubview(self.stackViewDelivering)
                    //Layout Setup stackViewAssigned
                    self.stackViewDelivering.translatesAutoresizingMaskIntoConstraints = false
                    self.stackViewDelivering.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                    self.stackViewDelivering.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    self.stackViewDelivering.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                    self.stackViewDelivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                    //**************wazeIcon**************
                    self.bottomView.addSubview(self.wazeIconDelivering)
                    self.wazeIconDelivering.isUserInteractionEnabled = true
                    let wazeTapDelivering = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                    wazeTapDelivering.latitude = self.latitudeArrivee
                    wazeTapDelivering.longitude = self.longitudeArrivee
                    self.wazeIconDelivering.addGestureRecognizer(wazeTapDelivering)
                    //Layout Setup
                    self.wazeIconDelivering.translatesAutoresizingMaskIntoConstraints = false
                    self.wazeIconDelivering.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.wazeIconDelivering.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconDelivering.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconDelivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                }
            }
        case "END":
            if (sender.yes){
//                let testImage : UIImageView = {
//                    let imageView = UIImageView()
//                    imageView.contentMode = .scaleAspectFit
//                    imageView.image = self.signatureViewController.fullSignatureImage!
//                    return imageView
//                }()
//                self.view.addSubview(testImage)
//                testImage.translatesAutoresizingMaskIntoConstraints = false
//                testImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true
//                testImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
//                testImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//                testImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
                
                            EndCourse(){

                let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
                let imagesArrivee = Array(course.colisImagesDataArrivee).map{
                      UIImage(data: $0)!
                  }
                SessionManager.currentSession.allCourses = SessionManager.currentSession.allCourses.filter{$0.code! != self.codeCourse }
                self.viewModel.uploadPhotos(images: imagesArrivee, codeCourse: self.codeCourse, type: "arrivee", vc: self)
                self.viewModel.uploadSignatureImage(image: self.signatureViewController.fullSignatureImage!, codeCourse: self.codeCourse, type: "arrivee", vc: self)
                RealmManager.sharedInstance.addSignatureImageData(course, data: self.signatureViewController.fullSignatureImage!.pngData()!, type: "arrivee")
                RealmManager.sharedInstance.EndCourse(course)
//                RealmManager.sharedInstance.EndCourse(primaryKey: self.codeCourse)
                print("Course: \(self.codeCourse) has ended")

                 let alert = UIAlertController(title: "Bravo!", message: "La course: \(self.codeCourse) est terminée. ", preferredStyle: .alert)
                 let action = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                 let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                 var destViewController : UIViewController
                     destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                     destViewController.toggleSideMenuView()
                     self.sideMenuController()?.setContentViewController(contentViewController: destViewController)                })
                     alert.addAction(action)
                     self.present(alert, animated:  true , completion: nil)

                }
            }else{
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.bottomViewHeightConstraint.constant = self.highHeight
                    self.view.layoutIfNeeded()
                })
                self.signatureViewController.reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.confirmationLabel_End.removeFromSuperview()
                    self.stackViewOuiNonBack_End.removeFromSuperview()
                    //**************stackViewDeposing**************
                    self.bottomView.addSubview(self.stackViewDeposing)
                    //Layout Setup
                    self.stackViewDeposing.translatesAutoresizingMaskIntoConstraints = false
                    self.stackViewDeposing.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: -20).isActive = true
                    self.stackViewDeposing.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    self.stackViewDeposing.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                    self.stackViewDeposing.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                    //************signatureViewController.view***********
                    self.view.addSubview(self.signatureViewController.view)
                    //Layout Setup
                    self.signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
                    self.signatureViewController.view.bottomAnchor.constraint(equalTo: self.stackViewDeposing.topAnchor, constant: -15).isActive = true
                    self.signatureViewController.view.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 35).isActive = true
                    self.signatureViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
                    self.signatureViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
                    //**************signatureView**************
                    self.signatureViewController.delegate = self
                    self.addChild(self.signatureViewController)
                    self.signatureViewController.didMove(toParent: self)
                    self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
                    //************signatureClient***********
                    self.view.addSubview(self.signatureClient)
                    //Layout Setup
                    self.signatureClient.translatesAutoresizingMaskIntoConstraints = false
                    self.signatureClient.topAnchor.constraint(equalTo: self.signatureViewController.view.topAnchor, constant: 0).isActive = true
                    self.signatureClient.centerXAnchor.constraint(equalTo: self.signatureViewController.view.centerXAnchor).isActive = true
                    self.signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
                    //**************cameraIcon**************
                    self.view.addSubview(self.cameraIconDeposing)
                    self.cameraIconDeposing.isUserInteractionEnabled = true
                    let tap = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
                    tap.param = "arrivee"
                    self.cameraIconDeposing.addGestureRecognizer(tap)
                    //Layout Setup
                    self.cameraIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                    self.cameraIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.cameraIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.cameraIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.cameraIconDeposing.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                    //**************imagesIcon**************
                    self.bottomView.addSubview(self.imagesIconDeposing)
                    self.imagesIconDeposing.isUserInteractionEnabled = true
                    let tap2 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
                    tap.param = "arrivee"
                    self.imagesIconDeposing.addGestureRecognizer(tap2)
                    //Layout Setup
                    self.imagesIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                    self.imagesIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.imagesIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.imagesIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.imagesIconDeposing.leadingAnchor.constraint(equalTo: self.cameraIconDeposing.trailingAnchor, constant: 20).isActive = true
                    //**************wazeIcon**************
                    self.bottomView.addSubview(self.wazeIconDeposing)
                    self.wazeIconDeposing.isUserInteractionEnabled = true
                    let wazeTapDeposing = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
                    wazeTapDeposing.latitude = self.latitudeArrivee
                    wazeTapDeposing.longitude = self.longitudeArrivee
                    self.wazeIconDeposing.addGestureRecognizer(wazeTapDeposing)
                    //Layout Setup
                    self.wazeIconDeposing.translatesAutoresizingMaskIntoConstraints = false
                    self.wazeIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
                    self.wazeIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    self.wazeIconDeposing.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                }
            }
        default:
            break
        }
    }
    func doCancel(cause:String){
        print(cause)
    }
  
    @objc func goBackButton(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        destViewController.toggleSideMenuView()
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
   //---------------------------------------------------------------------
    func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
        if (isEmpty) {
            self.ConfirmButton.alpha = 0.5
            self.FinishButton.alpha = 0.5
        }
        else {
            self.ConfirmButton.alpha = 1
            self.FinishButton.alpha = 1
            self.signatureImage = signatureViewController.fullSignatureImage
        }
    }
     //---------------------------------------------------------------------
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.signatureViewController.reset()
        NotificationCenter.default.removeObserver(self)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.sideMenuController()?.sideMenu?.delegate = self
        SetupView()
    }
    
    fileprivate func SetupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        SetupMapView()
        SetupBottomView()
        viewModel.showErrorClosure = {
            if let error = self.viewModel.error {
                let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated:  true , completion: nil)
            }
        }
    }
    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bottomViewHeightConstraint.constant = self.confirmationHeight + keyboardHeight
                self.view.layoutIfNeeded()
            })
        }
       
    }
   
    @objc func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.bottomViewHeightConstraint.constant = self.highHeight
            self.view.layoutIfNeeded()
        })
    }
    fileprivate func SetupBottomView() {
        //**************BottomView**************
         view.addSubview(bottomView)
        //Layout Setup
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: lowHeight)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomViewHeightConstraint.isActive = true
      
      //----------Init--------------
        if statusCode == "ASSIGNED"{
            bottomViewHeightConstraint.constant = lowHeight
            //**************stackViewAssigned**************
            bottomView.addSubview(stackViewAssigned)
            //Layout Setup stackViewAssigned
            stackViewAssigned.translatesAutoresizingMaskIntoConstraints = false
            stackViewAssigned.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
            stackViewAssigned.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackViewAssigned.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewAssigned.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************wazeIcon**************
            self.bottomView.addSubview(self.wazeIconAssigned)
            self.wazeIconAssigned.isUserInteractionEnabled = true
            let wazeTapAssigned = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
            wazeTapAssigned.latitude = self.latitudeArrivee
            wazeTapAssigned.longitude = self.longitudeArrivee
            self.wazeIconAssigned.addGestureRecognizer(wazeTapAssigned)
            //Layout Setup
            self.wazeIconAssigned.translatesAutoresizingMaskIntoConstraints = false
            self.wazeIconAssigned.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.wazeIconAssigned.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconAssigned.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconAssigned.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
        } else if statusCode == "ACCEPTEE" {
            bottomViewHeightConstraint.constant = lowHeight
            //**************stackViewAccepted**************
            bottomView.addSubview(stackViewAccepted)
            //Layout Setup stackViewAccepted
            stackViewAccepted.translatesAutoresizingMaskIntoConstraints = false
            stackViewAccepted.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
            stackViewAccepted.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackViewAccepted.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewAccepted.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************wazeIcon**************
            self.bottomView.addSubview(self.wazeIconAccepted)
            self.wazeIconAccepted.isUserInteractionEnabled = true
            let wazeTapAccepted = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
            wazeTapAccepted.latitude = self.latitudeArrivee
            wazeTapAccepted.longitude = self.longitudeArrivee
            self.wazeIconAccepted.addGestureRecognizer(wazeTapAccepted)
            //Layout Setup
            self.wazeIconAccepted.translatesAutoresizingMaskIntoConstraints = false
            self.wazeIconAccepted.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.wazeIconAccepted.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconAccepted.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconAccepted.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
        } else if statusCode == "LIVRAISON" {
            bottomViewHeightConstraint.constant = lowHeight
            //**************stackViewDelivering**************
            bottomView.addSubview(stackViewDelivering)
            //Layout Setup stackViewDelivering
            stackViewDelivering.translatesAutoresizingMaskIntoConstraints = false
            stackViewDelivering.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
            stackViewDelivering.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackViewDelivering.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewDelivering.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************wazeIcon**************
            self.bottomView.addSubview(self.wazeIconDelivering)
            self.wazeIconDelivering.isUserInteractionEnabled = true
            let wazeTapDelivering = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
            wazeTapDelivering.latitude = self.latitudeArrivee
            wazeTapDelivering.longitude = self.longitudeArrivee
            self.wazeIconDelivering.addGestureRecognizer(wazeTapDelivering)
            //Layout Setup
            self.wazeIconDelivering.translatesAutoresizingMaskIntoConstraints = false
            self.wazeIconDelivering.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.wazeIconDelivering.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconDelivering.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconDelivering.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            print("LIVRAISON")
        } else if statusCode == "ENLEVEMENT" {
            bottomViewHeightConstraint.constant = highHeight
            //**************stackViewPickup**************
            bottomView.addSubview(stackViewPickup)
            //Layout Setup stackViewAccepted
            stackViewPickup.translatesAutoresizingMaskIntoConstraints = false
            stackViewPickup.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
            stackViewPickup.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackViewPickup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewPickup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************stackViewType**************
            view.addSubview(stackViewType)
            //Layout Setup
            stackViewType.translatesAutoresizingMaskIntoConstraints = false
            stackViewType.heightAnchor.constraint(equalToConstant: 60)
            stackViewType.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 35).isActive = true
            stackViewType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //************signatureViewController.view***********
            view.addSubview(signatureViewController.view)
            //Layout Setup
            signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
            signatureViewController.view.bottomAnchor.constraint(equalTo: stackViewPickup.topAnchor, constant: -15).isActive = true
            signatureViewController.view.topAnchor.constraint(equalTo: stackViewType.bottomAnchor, constant: 10).isActive = true
            signatureViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            signatureViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************signatureView**************
            self.signatureViewController.delegate = self
            self.addChild(self.signatureViewController)
            self.signatureViewController.didMove(toParent: self)
            self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
            //************signatureClient***********
            view.addSubview(signatureClient)
            //Layout Setup
            signatureClient.translatesAutoresizingMaskIntoConstraints = false
            signatureClient.topAnchor.constraint(equalTo: signatureViewController.view.topAnchor, constant: 0).isActive = true
            signatureClient.centerXAnchor.constraint(equalTo: signatureViewController.view.centerXAnchor).isActive = true
            signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
            //**************cameraIcon**************
            self.view.addSubview(self.cameraIconPickup)
            self.cameraIconPickup.isUserInteractionEnabled = true
            let tap3 = MyTapGesture(target: self, action: #selector(self.showCamera(sender:)))
            tap3.param = "depart"
            self.cameraIconPickup.addGestureRecognizer(tap3)
            //Layout Setup
            self.cameraIconPickup.translatesAutoresizingMaskIntoConstraints = false
            self.cameraIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.cameraIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.cameraIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.cameraIconPickup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            //**************imagesIcon**************
            self.bottomView.addSubview(self.imagesIconPickup)
            self.imagesIconPickup.isUserInteractionEnabled = true
            let tap4 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
            tap4.param = "depart"
            self.imagesIconPickup.addGestureRecognizer(tap4)
            //Layout Setup
            self.imagesIconPickup.translatesAutoresizingMaskIntoConstraints = false
            self.imagesIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.imagesIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.imagesIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.imagesIconPickup.leadingAnchor.constraint(equalTo: self.cameraIconPickup.trailingAnchor, constant: 20).isActive = true
            //**************wazeIcon**************
            self.bottomView.addSubview(self.wazeIconPickup)
            self.wazeIconPickup.isUserInteractionEnabled = true
            let wazeTapPickup = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
            wazeTapPickup.latitude = self.latitudeArrivee
            wazeTapPickup.longitude = self.longitudeArrivee
            self.wazeIconPickup.addGestureRecognizer(wazeTapPickup)
            //Layout Setup
            self.wazeIconPickup.translatesAutoresizingMaskIntoConstraints = false
            self.wazeIconPickup.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.wazeIconPickup.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconPickup.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconPickup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
           print("ENLEVEMENT")
        } else if statusCode == "DECHARGEMENT"  {
            bottomViewHeightConstraint.constant = highHeight
            //**************stackViewDeposing**************
            bottomView.addSubview(stackViewDeposing)
            //Layout Setup
            stackViewDeposing.translatesAutoresizingMaskIntoConstraints = false
            stackViewDeposing.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20).isActive = true
            stackViewDeposing.heightAnchor.constraint(equalToConstant: 100).isActive = true
            stackViewDeposing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackViewDeposing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //************signatureViewController.view***********
            view.addSubview(signatureViewController.view)
            //Layout Setup
            signatureViewController.view.translatesAutoresizingMaskIntoConstraints = false
            signatureViewController.view.bottomAnchor.constraint(equalTo: stackViewDeposing.topAnchor, constant: -15).isActive = true
            signatureViewController.view.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 35).isActive = true
            signatureViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            signatureViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //**************signatureView**************
            self.signatureViewController.delegate = self
            self.addChild(self.signatureViewController)
            self.signatureViewController.didMove(toParent: self)
            self.signatureViewController.view.backgroundColor = UIColor(white: 230/255, alpha: 1)
            //************signatureClient***********
            view.addSubview(signatureClient)
            //Layout Setup
            signatureClient.translatesAutoresizingMaskIntoConstraints = false
            signatureClient.topAnchor.constraint(equalTo: signatureViewController.view.topAnchor, constant: 0).isActive = true
            signatureClient.centerXAnchor.constraint(equalTo: signatureViewController.view.centerXAnchor).isActive = true
            signatureClient.heightAnchor.constraint(equalToConstant: 20).isActive = true
            //**************cameraIcon**************
            bottomView.addSubview(cameraIconDeposing)
            cameraIconDeposing.isUserInteractionEnabled = true
            let tap = MyTapGesture(target: self, action: #selector(showCamera(sender:)))
            tap.param = "arrivee"
            cameraIconDeposing.addGestureRecognizer(tap)
            //Layout Setup
            cameraIconDeposing.translatesAutoresizingMaskIntoConstraints = false
            cameraIconDeposing.centerYAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
            cameraIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
            cameraIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
            cameraIconDeposing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            //**************imagesIcon**************
            bottomView.addSubview(self.imagesIconDeposing)
            imagesIconDeposing.isUserInteractionEnabled = true
            let tap2 = MyTapGesture(target: self, action: #selector(self.showImages(sender:)))
            tap.param = "arrivee"
            imagesIconDeposing.addGestureRecognizer(tap2)
            //Layout Setup
            imagesIconDeposing.translatesAutoresizingMaskIntoConstraints = false
            imagesIconDeposing.centerYAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
            imagesIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
            imagesIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imagesIconDeposing.leadingAnchor.constraint(equalTo: cameraIconDeposing.trailingAnchor, constant: 20).isActive = true
            //**************wazeIcon**************
            self.bottomView.addSubview(self.wazeIconDeposing)
            self.wazeIconDeposing.isUserInteractionEnabled = true
            let wazeTapDeposing = wazeTapGesture(target: self, action: #selector(self.openWaze(sender:)))
            wazeTapDeposing.latitude = self.latitudeArrivee
            wazeTapDeposing.longitude = self.longitudeArrivee
            self.wazeIconDeposing.addGestureRecognizer(wazeTapDeposing)
            //Layout Setup
            self.wazeIconDeposing.translatesAutoresizingMaskIntoConstraints = false
            self.wazeIconDeposing.centerYAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
            self.wazeIconDeposing.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconDeposing.widthAnchor.constraint(equalToConstant: 40).isActive = true
            self.wazeIconDeposing.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            print("DECHARGEMENT")
        } else{
            print("STATUSCODE UNKNOWN")
        }
    //----------------------------------
        //CANCEL CAUSES SETUP
        
        

        radioButton11.onSelect {
            self.radioButton21.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Client absent"

            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage11.alpha = 1
            })
        }
        radioButton11.onDeselect {
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage11.alpha = 0
            })
        }
        radioButton12.onSelect {
            self.radioButton22.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "J'ai eu une panne"

            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage12.alpha = 1
            })
        }
        radioButton12.onDeselect {
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage12.alpha = 0
            })
        }
        radioButton21.onSelect {
            self.radioButton11.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Marchandise non adaptée"
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage21.alpha = 1
            })
        }
        radioButton21.onDeselect {
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage21.alpha = 0
            })
        }
        radioButton22.onSelect {
            self.radioButton12.deselect()
            self.radioButton3.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "J'ai eu un accident"
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage22.alpha = 1
            })
        }
        radioButton22.onDeselect {
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage22.alpha = 0
            })
        }
        radioButton3.onSelect {
            self.radioButton11.deselect()
            self.radioButton21.deselect()
            self.radioButton12.deselect()
            self.radioButton22.deselect()
            self.radioButton4.deselect()
            self.CancelCause = "Rue inaccessible"
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage3.alpha = 1
            })
        }
        radioButton3.onDeselect {
            UIView.animate(withDuration: 0.1, animations: {
                self.causeImage3.alpha = 0
            })
        }
        radioButton4.onSelect {
            self.radioButton11.deselect()
            self.radioButton21.deselect()
            self.radioButton12.deselect()
            self.radioButton22.deselect()
            self.radioButton3.deselect()
            self.autreTextView.becomeFirstResponder()
            UIView.animate(withDuration: 0.1, animations: {
                self.autreTextView.alpha = 1
            })
            self.CancelCause = "La course a été annulée pour d'autres raisons"
        }
        radioButton4.onDeselect {
            self.view.endEditing(true)
            self.autreTextView.text = ""
            UIView.animate(withDuration: 0.1, animations: {
                self.autreTextView.alpha = 0
            })
        }

    }
    fileprivate func SetupMapView() {
        //**************mapView**************
        let bounds =  GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: latitudeDepart, longitude: longitudeDepart), coordinate: CLLocationCoordinate2D(latitude: latitudeArrivee, longitude: longitudeArrivee))
        let update: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
        let camera = GMSCameraPosition.camera(withLatitude: latitudeDepart, longitude: longitudeDepart, zoom: 6.0)
   
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 140)
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.mapView.animate(with: update)
                self.viewModel.drawPath(startLocation: CLLocation(latitude: self.latitudeDepart, longitude: self.longitudeDepart), endLocation: CLLocation(latitude: self.latitudeArrivee, longitude: self.longitudeArrivee), mapView: self.mapView)
        }
        self.view.addSubview(mapView)
        //**************Markers**************
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: latitudeDepart, longitude: longitudeDepart)
        marker1.title = "Départ"
        marker1.snippet = adresseDepart
        marker1.map = mapView
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: latitudeArrivee, longitude: longitudeArrivee)
        marker2.title = "Arrivée"
        marker2.snippet = adresseArrivee
        marker2.map = mapView
    }


}
//extension CourseDetailsController : UICollectionViewDataSource  {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
//        return course.colisImagesData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
//        let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
//
//        cell.colisImageView.image = UIImage(data: course.colisImagesData[indexPath.row])
//        return cell
//    }
//
//    class CollectionViewCell: UICollectionViewCell {
//        override init(frame: CGRect){
//            super.init(frame: frame)
//            setupCollectionViewCell()
//        }
//
//        let colisImageView : UIImageView = {
//            let imageView =  UIImageView()
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            return imageView
//        }()
//
//
//
//        func setupCollectionViewCell(){
//            addSubview(colisImageView)
////            colisImageView.frame = super.frame
//            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", metrics: nil, views: ["v0":colisImageView]))
//            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", metrics: nil, views: ["v0":colisImageView]))
//        }
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
//}
