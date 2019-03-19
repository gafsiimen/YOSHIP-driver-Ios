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
import EasyPeasy

class HomeViewController: UIViewController, ENSideMenuDelegate {
    //Local Variables
     var sideMenu:ENSideMenu!
     var Bar = UIView()
     let barHeight = CGFloat(3)
     var courses : [Course] = []
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
        SetupHomeView.sharedInstance.SetupBar(Bar: Bar, view: view, BarView: BarView, x: 0, y: self.StatusImage.frame.height+self.BarView.frame.height+self.SeguementedControl.frame.height-self.barHeight, width: self.view.frame.width/2, height: self.barHeight)
    }
    fileprivate func animateBar(barX: CGFloat) {
        if barX == 0 {
            SetupHomeView.sharedInstance.animateBar(Bar: Bar, x: self.view.frame.width/2, y: self.StatusImage.frame.height+self.BarView.frame.height+self.SeguementedControl.frame.height-self.barHeight, width: self.view.frame.width/2, height: self.barHeight)
        } else {
            SetupHomeView.sharedInstance.animateBar(Bar: Bar, x: 0, y: self.StatusImage.frame.height+self.BarView.frame.height+self.SeguementedControl.frame.height-self.barHeight, width: self.view.frame.width/2, height: self.barHeight)
        }
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
            animateBar(barX: Bar.frame.minX)
            viewModel.fetchCourses(tag: "accepted")
        case 1:
            animateBar(barX: Bar.frame.minX)
            viewModel.fetchCourses(tag: "assigned")
        default:
            break
        }
    }
    
    //--------------------------------------------------------------------------------------------
    fileprivate func SetupTableViewDataSource() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.viewModel.fetchCourses(tag: "accepted")
//            self.tableView.tableFooterView = UIView()
        }
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
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) 
      cell.textLabel?.text = courses[indexPath.row].lettreDeVoiture.code
        
//        cell?.adressLabel.text = courses[indexPath.row].adresseDepart.address
//        cell?.deliveryDate.text = courses[indexPath.row].dateLivraison
//        cell?.codeLV.text = courses[indexPath.row].lettreDeVoiture.code
//        cell?.iconIndicator.image = UIImage(named: "M")
        
//        cell.adressLabel?.text = "\(courses[indexPath.row].adresseDepart.address)"
//        cell.deliveryDate?.text = "\(courses[indexPath.row].dateLivraison)"
//        cell.codeLV?.text = "\(courses[indexPath.row].lettreDeVoiture.code)"
//        cell.iconIndicator?.image = UIImage(named: "M")
        return cell
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == C.CellHeight.close {
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
               cell.unfold(false, animated: false, completion: nil)
            } else {
               cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
}
