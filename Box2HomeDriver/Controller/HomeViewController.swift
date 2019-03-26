//
//  HomeViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/15/19.
//  Copyright © 2019 MacHD. All rights reserved.
//
import Foundation
import UIKit
import NVActivityIndicatorView
import FoldingCell
import SwiftEventBus

class HomeViewController: UIViewController, ENSideMenuDelegate {
    //Local Variables
     var sideMenu:ENSideMenu!
     var Bar = UIView()
     let barHeight = CGFloat(3)
     var courses : [Course] = []
    let dateFormatter = DateFormatter()
    let formatter = NumberFormatter()
    
    //---
   
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 150 // equal or greater foregroundView height
            static let open: CGFloat = 300 // equal or greater containerView height
        }
    }
    //---
   
    
    var cellHeights : [CGFloat] = []
    //Dependecies`
    let viewModel = HomeViewModel(HomeRepository: HomeRepository())
    //IBOutlets
    @IBOutlet weak var SeguementedControl: UISegmentedControl!
    @IBOutlet weak var StatusImage: UIImageView!
    @IBOutlet weak var BarView: UIView!
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var loading: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    //--------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
    }
  
    
    fileprivate func SetupView() {
        self.sideMenuController()?.sideMenu?.delegate = self
        tableView.separatorStyle = .none
//      tableView.tableFooterView = UIView()
        SetupTableViewDataSource()
        SetupStatusImage()
        SetupBarView()
        SetupBar()
        SetupMenuButton()
        SetupMapButton()
        SetupSeguementedControl()
    }
    fileprivate func SetupStatusImage() {
          SetupHomeView.sharedInstance.SetupStatusImage(StatusImage: StatusImage, vc: self)
    }
    fileprivate func SetupSeguementedControl() {
        SetupHomeView.sharedInstance.SetupSeguementedControl(SeguementedControl: SeguementedControl)
    }
    fileprivate func SetupMenuButton(){
        SetupHomeView.sharedInstance.SetupMenuButton(MenuButton: MenuButton)
    }
    fileprivate func SetupMapButton(){
        SetupHomeView.sharedInstance.SetupMapButton(MapButton: MapButton)
    }
    fileprivate func SetupBarView(){
        SetupHomeView.sharedInstance.SetupBarView(BarView: BarView)
    }
    fileprivate func SetupBar() {
        SetupHomeView.sharedInstance.SetupBar(Bar: Bar, view: view, BarView: BarView, x: 0,y:UIScreen.main.bounds.height/5.5, width: self.view.frame.width/2, height: self.barHeight)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.Bar.bottomAnchor.constraint(equalTo: self.SeguementedControl.bottomAnchor).isActive = true
        }
    }
    fileprivate func animateBar(barX: CGFloat) {
            SetupHomeView.sharedInstance.animateBar(Bar: Bar, x: barX, y: self.StatusImage.frame.height+self.BarView.frame.height+self.SeguementedControl.frame.height-self.barHeight, width: self.view.frame.width/2, height: self.barHeight)
    }
    //--------------------------------------------------------------------------------------------
    @IBAction func MapButton(_ sender: Any) {
        loading.type = NVActivityIndicatorType.ballPulse
        loading.startAnimating()
        loading.color = .red
        toggleSideMenuView()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController")
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    //--------------------------------------------------------------------------------------------
    
    @IBAction func MenuButton(_ sender: Any) {
         toggleSideMenuView()
    }
    //--------------------------------------------------------------------------------------------
    @IBAction func SeguementedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            CloseAllCells(animated: false, completionAfterCellCloses: nil){
                self.animateBar(barX: 0)
                self.viewModel.fetchCourses(tag: "accepted")
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        case 1:
            CloseAllCells(animated: false, completionAfterCellCloses: nil){
                self.animateBar(barX: self.view.frame.width/2)
                self.viewModel.fetchCourses(tag: "assigned")
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

            }
        default:
            break
        }
    }
    
    //--------------------------------------------------------------------------------------------
    @objc func Rswipe(){
        CloseAllCells(animated: false, completionAfterCellCloses: nil){
            self.SeguementedControl.selectedSegmentIndex = 0
            self.animateBar(barX: 0)
            self.viewModel.fetchCourses(tag: "accepted")
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        }
    }
   
    @objc func Lswipe(){
        CloseAllCells(animated: false, completionAfterCellCloses: nil){
            self.SeguementedControl.selectedSegmentIndex = 1
            self.animateBar(barX: self.view.frame.width/2)
            self.viewModel.fetchCourses(tag: "assigned")
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        }
    }
    fileprivate func SetupTableViewDataSource() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "reload"), object: nil)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.viewModel.fetchCourses(tag: "accepted")
        }
        
        let Rightswipe = UISwipeGestureRecognizer(target: self, action: #selector(Rswipe))
        let Leftswipe = UISwipeGestureRecognizer(target: self, action: #selector(Lswipe))
        Rightswipe.direction = .right
        Leftswipe.direction = .left
        tableView.addGestureRecognizer(Rightswipe)
        tableView.addGestureRecognizer(Leftswipe)
//
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1:00")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        viewModel.CoursesFetchedClosure = {
            if (SessionManager.currentSession.assignedCourses.count != 0){
            self.SeguementedControl.setTitle("ATTRIBUÉES(\(SessionManager.currentSession.assignedCourses.count))", forSegmentAt: 1)
            }
            if (SessionManager.currentSession.acceptedCourses.count != 0){
            self.SeguementedControl.setTitle("EN COURS(\(SessionManager.currentSession.acceptedCourses.count))", forSegmentAt: 0)
            }
            self.courses = self.viewModel.CoursesFetched!
            self.cellHeights = (0..<self.courses.count).map { _ in C.CellHeight.close }
            self.tableView.reloadData()
            print(self.viewModel.CoursesFetched!)
        }
    }
    //--------------------------------------------------------------------------------------------
    @objc func refresh(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.viewModel.fetchCourses(tag: notification.object as! String)
            
        }
    }
 
    fileprivate func CloseAllCells(animated: Bool,completionAfterCellCloses: (()->())?,completionAfterAllCellsClose: (()->())?) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if (cellHeights[row] == C.CellHeight.open){ guard case let otherCell as CourseCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) else {return}
                CloseCell(IndexPath(row: row, section: 0), otherCell, tableView,completion: completionAfterCellCloses, animated: animated)
            }
        }
        completionAfterAllCellsClose?()
    }
    
}
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: backgroundColor!), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let segAttributesSelected: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor(white: 255, alpha: 0.8)
        ]
        let segAttributesNormal: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor(white: 255, alpha: 0.4)
        ]
       
            self.setTitleTextAttributes(segAttributesSelected as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.selected)
             self.setTitleTextAttributes(segAttributesNormal as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.normal)
         self.setTitleTextAttributes(segAttributesSelected as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.highlighted)
        
       
    }
//    func normal()  {
//        let segAttributesNormal: NSDictionary = [
//            NSAttributedString.Key.foregroundColor: UIColor(white: 255, alpha: 0.2)
//        ]
//          self.setTitleTextAttributes(segAttributesNormal as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.normal)
//    }
//
//    func selected()  {
//        let segAttributesSelected: NSDictionary = [
//            NSAttributedString.Key.foregroundColor: UIColor(white: 255, alpha: 0.8)
//        ]
//          self.setTitleTextAttributes(segAttributesSelected as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: UIControl.State.selected)
//    }
    

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
   
    fileprivate func SetupCourseCell(_ cell: CourseCell, _ indexPath: IndexPath) {
        collapsedCellSetup(cell, indexPath)
        expandedCellSetup(cell, indexPath)
    }
 //--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! CourseCell
        SetupCourseCell(cell, indexPath)
        return cell
    }
 //--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
 //--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
//--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as CourseCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cellHeights[indexPath.row] == C.CellHeight.close {
            CloseOtherCells(tableView, indexPath)
            ExpandCell(indexPath, cell, tableView)
        } else {
            CloseCell(indexPath, cell, tableView,completion: nil, animated: true)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as CourseCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion: nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
 //--------------------------------------------------------------------------------------
    fileprivate func ShowContainerViewSubviews(_ cell: CourseCell) {
        cell.clientContainer.alpha = 1
//        cell.clientIcon.alpha = 1
//        cell.firstName.alpha = 1
//        cell.lastName.alpha = 1
//        cell.phone.alpha = 1
    }
    fileprivate func HideContainerViewSubviews(_ cell: CourseCell) {
        cell.clientContainer.alpha = 0
//        cell.clientIcon.alpha = 0
//        cell.firstName.alpha = 0
//        cell.lastName.alpha = 0
//        cell.phone.alpha = 0
    }
 //--------------------------------------------------------------------------------------
    fileprivate func ExpandCell(_ indexPath: IndexPath, _ cell: CourseCell, _ tableView: UITableView) {
        cellHeights[indexPath.row] = C.CellHeight.open
        
        cell.unfold(true, animated: true){
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.ShowContainerViewSubviews(cell)
        }
    }
 //--------------------------------------------------------------------------------------
    fileprivate func CloseCell(_ indexPath: IndexPath, _ cell: CourseCell, _ tableView: UITableView,completion: (() -> ())?,animated :Bool) {
        cellHeights[indexPath.row] = C.CellHeight.close
        HideContainerViewSubviews(cell)
        cell.unfold(false, animated: animated,completion: completion)
        
    }
   
//--------------------------------------------------------------------------------------
    fileprivate func CloseOtherCells(_ tableView: UITableView, _ indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if (row != indexPath.row && cellHeights[row] == C.CellHeight.open){ guard case let otherCell as CourseCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) else {return}
                CloseCell(IndexPath(row: row, section: 0), otherCell, tableView,completion: nil, animated: true)
            }
        }
    }
    //---------------------------------------------------------------------------------------------
    fileprivate func expandedCellSetup(_ cell: CourseCell, _ indexPath: IndexPath) {
        //--------------------------------------------------------------------------------------
        //color Setup
        cell.clientContainer.backgroundColor = .white
        cell.clientIcon.image = cell.clientIcon.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.clientIcon.tintColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.firstName.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.lastName.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.phone.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        //--------------------------------------------------------------------------------------
        //Layout Setup
        //**************clientContainer**************
        cell.clientContainer.translatesAutoresizingMaskIntoConstraints = false
        cell.clientContainer.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 10).isActive = true
        cell.clientContainer.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 10).isActive = true
        cell.clientContainer.trailingAnchor.constraint(equalTo: cell.phone.trailingAnchor, constant: 10).isActive = true
        cell.clientContainer.heightAnchor.constraint(equalToConstant: 160).isActive = true
//        cell.clientContainer.widthAnchor.constraint(equalToConstant: 165).isActive = true
        //**************ClientIcon**************
        cell.clientIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.clientIcon.topAnchor.constraint(equalTo: cell.clientContainer.topAnchor, constant: 0).isActive = true
        cell.clientIcon.leadingAnchor.constraint(equalTo: cell.clientContainer.leadingAnchor, constant: 15).isActive = true
        cell.clientIcon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        cell.clientIcon.widthAnchor.constraint(equalToConstant: 75).isActive = true
        //**************firstName**************
        cell.firstName.translatesAutoresizingMaskIntoConstraints = false
        cell.firstName.topAnchor.constraint(equalTo: cell.clientContainer.topAnchor, constant: 20).isActive = true
        cell.firstName.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.firstName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.firstName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //**************lastName**************
        cell.lastName.translatesAutoresizingMaskIntoConstraints = false
        cell.lastName.topAnchor.constraint(equalTo: cell.firstName.bottomAnchor, constant: 5).isActive = true
        cell.lastName.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.lastName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.lastName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //**************phone**************
        cell.phone.translatesAutoresizingMaskIntoConstraints = false
        cell.phone.topAnchor.constraint(equalTo: cell.lastName.bottomAnchor, constant: 5).isActive = true
        cell.phone.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.phone.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.phone.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //--------------------------------------------------------------------------------------
        //text Setup
        cell.firstName.text = courses[indexPath.row].commande.client.firstname
        cell.lastName.text = courses[indexPath.row].commande.client.lastname
        cell.phone.text = courses[indexPath.row].commande.client.phone
        //--------------------------------------------------------------------------------------
        //Style Setup : https://github.com/lionhylra/iOS-UIFont-Names
        cell.firstName.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.lastName.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.phone.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        //--------------------------------------------------------------------------------------
        //behaviour Setup
        cell.firstName.numberOfLines = 0
        cell.lastName.numberOfLines = 0
        cell.phone.numberOfLines = 0
        cell.clientIcon.contentMode = .scaleAspectFit
        cell.clientContainer.layer.cornerRadius = 10
    }
 //--------------------------------------------------------------------------------------
    fileprivate func collapsedCellSetup(_ cell: CourseCell, _ indexPath: IndexPath) {
        let trailingOffset: CGFloat = -30
        let leadingOffset: CGFloat = 50
        let topOffset: CGFloat = 15
        let labelHeight: CGFloat = 30
        let IconHeightWidth: CGFloat = 20
        
        //--------------------------------------
        //color Setup
        cell.adresseDepart.backgroundColor = .clear
        cell.adresseArrivee.backgroundColor = .clear
        cell.StatusAndDate.textColor = .orange
        cell.LVcode.textColor = .darkGray
        //--------------------------------------
        //Layout Setup
        //**************departIcon**************
        cell.departIcon.translatesAutoresizingMaskIntoConstraints = false
         cell.departIcon.centerYAnchor.constraint(equalTo: cell.adresseDepart.centerYAnchor).isActive = true
        cell.departIcon.trailingAnchor.constraint(equalTo: cell.adresseDepart.leadingAnchor, constant: -IconHeightWidth/2).isActive = true
        cell.departIcon.heightAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        cell.departIcon.widthAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        //**************arriveeIcon**************
        cell.arriveeIcon.translatesAutoresizingMaskIntoConstraints = false
         cell.arriveeIcon.centerYAnchor.constraint(equalTo: cell.adresseArrivee.centerYAnchor).isActive = true
        cell.arriveeIcon.trailingAnchor.constraint(equalTo: cell.adresseArrivee.leadingAnchor, constant: -IconHeightWidth/2).isActive = true
        cell.arriveeIcon.heightAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        cell.arriveeIcon.widthAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        //**************StatusAndDate**************
        cell.StatusAndDate.translatesAutoresizingMaskIntoConstraints = false
        cell.StatusAndDate.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset+2*labelHeight).isActive = true
        cell.StatusAndDate.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.StatusAndDate.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.StatusAndDate.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //**************adresseArrivee**************
        cell.adresseArrivee.translatesAutoresizingMaskIntoConstraints = false
        cell.adresseArrivee.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset + labelHeight).isActive = true
        cell.adresseArrivee.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.adresseArrivee.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.adresseArrivee.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        //**************adresseDepart**************
        cell.adresseDepart.translatesAutoresizingMaskIntoConstraints = false
        cell.adresseDepart.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset).isActive = true
        cell.adresseDepart.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.adresseDepart.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.adresseDepart.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        //**************LVcode**************
        cell.LVcode.translatesAutoresizingMaskIntoConstraints = false
        cell.LVcode.bottomAnchor.constraint(equalTo: cell.foregroundView.bottomAnchor, constant: trailingOffset/3).isActive = true
        cell.LVcode.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset/3).isActive = true

        //--------------------------------------
        //text Setup
        cell.LVcode.text = courses[indexPath.row].lettreDeVoiture.code
        //------
        cell.adresseDepart.text = courses[indexPath.row].adresseDepart.address
        //------
        cell.adresseArrivee.text = courses[indexPath.row].adresseArrivee.address
        //------
        let status = "\(courses[indexPath.row].status.label)"
        let deliveryWindow = courses[indexPath.row].dateDemarrageMeta.deliveryWindow
        let dateDemarrage = dateFormatter.date(from: courses[indexPath.row].dateDemarrage)!
        let deadlineDate = Calendar.current.date(byAdding: .minute, value: deliveryWindow, to: dateDemarrage, wrappingComponents: false)!
        let yyyyMMdd = "\(Calendar.current.component(.day, from: dateDemarrage ))-\(Calendar.current.component(.month, from: dateDemarrage ))-\(Calendar.current.component(.year, from: dateDemarrage ))"
        let hour1 = "\(Calendar.current.component(.hour, from: dateDemarrage ))h"
        let hour2 = "\(Calendar.current.component(.hour, from: deadlineDate))h"
        cell.StatusAndDate.text = "\(status) : \(yyyyMMdd) entre \(hour1) et \(hour2)"
        //------
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        formatter.roundingMode = .up
//        cell.estimatedKM.text = "\(String(describing: formatter.string(from: NSNumber(value: courses[indexPath.row].estimatedKM))!)) Km"
    
        //--------------------------------------
        //Style Setup : https://github.com/lionhylra/iOS-UIFont-Names
        cell.adresseDepart.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.adresseArrivee.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.StatusAndDate.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.LVcode.font = UIFont(name: "Copperplate-Light", size: CGFloat(12))
//        cell.estimatedKM.font = UIFont(name: "Copperplate-Light", size: CGFloat(17))
        //--------------------------------------
        //behaviour Setup
        cell.adresseDepart.numberOfLines = 0
        cell.adresseArrivee.numberOfLines = 0
        cell.StatusAndDate.numberOfLines = 0
        cell.departIcon.contentMode = .scaleAspectFit
        cell.arriveeIcon.contentMode = .scaleAspectFit
    }
}
