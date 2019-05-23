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
    var courses : [Course] = []

    let dateFormatter = DateFormatter()
    let formatter = NumberFormatter()
    var reachability: Reachability!


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
    @IBOutlet weak var leadingBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthBarConstraint: NSLayoutConstraint!
    //--------------------------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchCourses(tag: "accepted")
    }
    override func viewWillAppear(_ animated: Bool) {
        toggleSideMenuView()
        toggleSideMenuView()
    }
    //----------------------
    let connectionLostView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .orange
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        label.text = "Problème de connexion !"
        label.font = UIFont(name: "Copperplate-Light", size: CGFloat(16))!
        return label
    }()
    //--------------------------
    @objc
    func connectionLost(){
        self.connectionLostView.removeFromSuperview()
        self.view.addSubview(self.connectionLostView)
        //Layout Setup
        self.connectionLostView.translatesAutoresizingMaskIntoConstraints = false
        self.connectionLostView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.connectionLostView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.connectionLostView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.connectionLostView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.connectionLostView.alpha = 1
        }
    }
     @objc
     func connectionEstablished(){
        UIView.animate(withDuration: 0.5) {
            self.connectionLostView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.connectionLostView.removeFromSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("storedStatus: \n",RealmManager.sharedInstance.fetchCourses().first?.status!.description)
//        print("storedId: \n",RealmManager.sharedInstance.fetchCourses().first?.id.value!)
//        print("allCourses: \n",SessionManager.currentSession.allCourses.count)
//        print("acceptedCourses: \n",SessionManager.currentSession.acceptedCourses.first?.status?.code ?? "")
//        print("assignedCourses: \n",SessionManager.currentSession.assignedCourses.description)
       
 NotificationCenter.default.addObserver(self, selector: #selector(connectionLost), name: NSNotification.Name(rawValue: "unreachable"), object: nil)
 NotificationCenter.default.addObserver(self, selector: #selector(connectionEstablished), name: NSNotification.Name(rawValue: "reachable"), object: nil)
        
//        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
//            self.connectionEstablished()
//        }
//        NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
//            self.connectionLost()
//        }
        // Initialise reachability
        reachability = Reachability()
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        SetupView()
    
    }
  
    @objc func networkStatusChanged(_ notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            DispatchQueue.main.async {
                print("Reachable via WiFi")
//                NotificationCenter.default.post(name: NSNotification.Name("reachable"), object: nil)
            }
        case .cellular:
            DispatchQueue.main.async {
                print("Reachable via Cellular")
//                NotificationCenter.default.post(name: NSNotification.Name("reachable"), object: nil)
            }
        case .none:
            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: NSNotification.Name("unreachable"), object: nil)
                print("Network not reachable")
            }
        }
        
        
    }
    
    fileprivate func SetupView() {
        self.hideKeyboardWhenTappedAround()
        self.sideMenuController()?.sideMenu?.delegate = self
        tableView.separatorStyle = .none
//      tableView.tableFooterView = UIView()
        SetupTableView()
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
            self.leadingBarConstraint.constant = 0
            self.widthBarConstraint.constant = self.view.frame.width/2
    }
    fileprivate func animateBar(barX: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.leadingBarConstraint.constant = barX
            self.view.layoutIfNeeded()
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
            CloseAllCells(animated: false, completionAfterCellCloses: nil){
                self.animateBar(barX: 0)
                self.viewModel.fetchCourses(tag: "accepted")
            }
        case 1:
            CloseAllCells(animated: false, completionAfterCellCloses: nil){
                self.animateBar(barX: self.view.frame.width/2)
                self.viewModel.fetchCourses(tag: "assigned")
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
        }
    }
   //--------------------------------------------------------------------------------------------
    @objc func Lswipe(){
        CloseAllCells(animated: false, completionAfterCellCloses: nil){
            self.SeguementedControl.selectedSegmentIndex = 1
            self.animateBar(barX: self.view.frame.width/2)
            self.viewModel.fetchCourses(tag: "assigned")
        }
    }
   //--------------------------------------------------------------------------------------------
    @objc func refresh(_ notification: Notification) {
//        print("I AM THE NOTIFICATION")
        if SeguementedControl.selectedSegmentIndex == 1{
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.viewModel.fetchCourses(tag: "assigned")
            }
        } else {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.viewModel.fetchCourses(tag: "accepted")
            }
        }
    }
  //--------------------------------------------------------------------------------------------
   
    fileprivate func SetupTableView() {
         tableView.estimatedRowHeight = C.CellHeight.close
         tableView.rowHeight = UITableView.automaticDimension
      
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "reload"), object: nil)
       
      
            
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
//            print(self.viewModel.CoursesFetched!)
        }
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
    func RefetchCurrentSegment(completion: (()->())?) {
        switch self.SeguementedControl.selectedSegmentIndex{
        case 0: self.viewModel.fetchCourses(tag: "accepted")
        case 1: self.viewModel.fetchCourses(tag: "assigned")
        default:
            break
        }
        completion?()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as CourseCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        if cellHeights[indexPath.row] == C.CellHeight.close {
            CloseAllCells(animated: true, completionAfterCellCloses: nil ){
            self.ExpandCell(indexPath, cell, tableView, animated: true)
            }
        } else {
            CloseCell(indexPath, cell, tableView, animated: true, completion: nil)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if case let cell as CourseCell = cell {
//           cell.unfold(false, animated: false, completion: nil)
//        }
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CourseCell = cell else {return}
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion: nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //endEditing closes keyboard
        view.endEditing(true)
        CloseAllCells(animated: true, completionAfterCellCloses: nil, completionAfterAllCellsClose: nil)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
 //--------------------------------------------------------------------------------------
    fileprivate func ShowContainerViewSubviews(_ cell: CourseCell, _ SegIndex: Int) {
        cell.clientIcon.alpha = 1
        cell.colisIcon.alpha = 1
        cell.colisQuantityLabel.alpha = 1
        cell.firstNameLabel.alpha = 1
        cell.lastNameLabel.alpha = 1
        cell.phoneLabel.alpha = 1
        cell.NewColisQuantityTF.alpha = 1-CGFloat(SegIndex)
        cell.updateColisQuantityButton.alpha = 1-CGFloat(SegIndex)
        cell.ButtonStackView.alpha = 1
        cell.ContainerViewLVCodeLabel.alpha = 1
        cell.observationsLabel.alpha = 1
        cell.observationsTextView.alpha = 1
        cell.CourseDetailsButton.alpha = 1
    }
    fileprivate func HideContainerViewSubviews(_ cell: CourseCell) {
        cell.colisQuantityLabel.alpha = 0
        cell.clientIcon.alpha = 0
        cell.colisIcon.alpha = 0
        cell.firstNameLabel.alpha = 0
        cell.lastNameLabel.alpha = 0
        cell.phoneLabel.alpha = 0
        cell.NewColisQuantityTF.alpha = 0
        cell.updateColisQuantityButton.alpha = 0
        cell.ButtonStackView.alpha = 0
        cell.ContainerViewLVCodeLabel.alpha = 0
        cell.observationsLabel.alpha = 0
        cell.observationsTextView.alpha = 0
        cell.CourseDetailsButton.alpha = 0
    }
 //--------------------------------------------------------------------------------------
    fileprivate func ExpandCell(_ indexPath: IndexPath, _ cell: CourseCell, _ tableView: UITableView,animated: Bool) {
        cellHeights[indexPath.row] = C.CellHeight.open
        
        cell.unfold(true, animated: animated){
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            self.ShowContainerViewSubviews(cell,self.SeguementedControl.selectedSegmentIndex)
        }
    }
 //--------------------------------------------------------------------------------------
    fileprivate func CloseCell(_ indexPath: IndexPath, _ cell: CourseCell, _ tableView: UITableView,animated :Bool,completion: (() -> ())?) {
        cellHeights[indexPath.row] = C.CellHeight.close
        HideContainerViewSubviews(cell)
        cell.unfold(false, animated: animated,completion: completion)
        
    }
    //--------------------------------------------------------------------------------------------
    fileprivate func CloseAllCells(animated: Bool,completionAfterCellCloses: (()->())?,completionAfterAllCellsClose: (()->())?) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            if (cellHeights[row] == C.CellHeight.open){ guard case let cell as CourseCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) else {return}
                CloseCell(IndexPath(row: row, section: 0), cell, tableView,animated: animated, completion: completionAfterCellCloses)
            }
        }
//       self.RefetchCurrentSegment(completion: nil)
        completionAfterAllCellsClose?()
    }
    //---------------------------------------------------------------------------------------------
    fileprivate func expandedCellSetup(_ cell: CourseCell, _ indexPath: IndexPath) {
        //--------------------------------------------------------------------------------------
        //color Setup
//        cell.clientContainer.backgroundColor = .white
       
        //--------------------------------------------------------------------------------------
        //Find font name here : https://github.com/lionhylra/iOS-UIFont-Names
        //**************ClientIcon**************
        cell.clientIcon.contentMode = .scaleAspectFit
        cell.clientIcon.image = cell.clientIcon.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.clientIcon.tintColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        //Layout Setup
        cell.clientIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.clientIcon.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 0).isActive = true
        cell.clientIcon.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 25).isActive = true
        cell.clientIcon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        cell.clientIcon.widthAnchor.constraint(equalToConstant: 75).isActive = true
        //**************firstName**************
        cell.firstNameLabel.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.firstNameLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.firstName = courses[indexPath.row].commande!.client!.firstname!
        cell.firstNameLabel.numberOfLines = 0
        //Layout Setup
        cell.firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.firstNameLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 30).isActive = true
        cell.firstNameLabel.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.firstNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.firstNameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //**************lastName**************
        cell.lastNameLabel.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.lastName = courses[indexPath.row].commande!.client!.lastname!
        cell.lastNameLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.lastNameLabel.numberOfLines = 0
        //Layout Setup
        cell.lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.lastNameLabel.topAnchor.constraint(equalTo: cell.firstNameLabel.bottomAnchor, constant: 5).isActive = true
        cell.lastNameLabel.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.lastNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.lastNameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //**************phone**************
        cell.phoneLabel.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.phone = courses[indexPath.row].commande!.client!.phone!
        cell.phoneLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.phoneLabel.numberOfLines = 0
        //Layout Setup
        cell.phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.phoneLabel.topAnchor.constraint(equalTo: cell.lastNameLabel.bottomAnchor, constant: 5).isActive = true
        cell.phoneLabel.leadingAnchor.constraint(equalTo: cell.clientIcon.trailingAnchor, constant: 10).isActive = true
        cell.phoneLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.phoneLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //**************colisIcon**************
        cell.colisIcon.image = cell.colisIcon.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.colisIcon.tintColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.colisIcon.contentMode = .scaleAspectFit
        //Layout Setup
        cell.colisIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.colisIcon.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 25).isActive = true
        cell.colisIcon.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -45).isActive = true
        cell.colisIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cell.colisIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //**************colisQuantity**************
        cell.colisQuantityLabel.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.colisQuantity = courses[indexPath.row].nombreColis.value!
        cell.colisQuantityLabel.font = UIFont(name: "Copperplate", size: CGFloat(19))
        //Layout Setup
        cell.colisQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.colisQuantityLabel.centerYAnchor.constraint(equalTo: cell.colisIcon.centerYAnchor).isActive = true
        cell.colisQuantityLabel.leadingAnchor.constraint(equalTo: cell.colisIcon.trailingAnchor, constant: 10).isActive = true
        cell.colisQuantityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.colisQuantityLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //**************NewColisQuantityTF**************
        let placeholderPaddingLeft = 7
        cell.NewColisQuantityTF.layer.borderColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1).cgColor
        cell.NewColisQuantityTF.layer.borderWidth = 1
        cell.NewColisQuantityTF.layer.cornerRadius = 6.5
        cell.NewColisQuantityTF.textColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: placeholderPaddingLeft, height: 20))
        cell.NewColisQuantityTF.leftView = paddingView
        cell.NewColisQuantityTF.leftViewMode = .always
        cell.NewColisQuantityTF.isUserInteractionEnabled = true
        cell.NewColisQuantityTF.backgroundColor = UIColor.clear
        cell.NewColisQuantityTF.layer.borderColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1).cgColor
        cell.NewColisQuantityTF.attributedPlaceholder = NSAttributedString(string: "New Value", attributes:[NSAttributedString.Key.font : UIFont(name: "Copperplate-Light", size: CGFloat(12))!,NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 0.6)])
        cell.NewColisQuantityTF.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        //Layout Setup
        cell.NewColisQuantityTF.translatesAutoresizingMaskIntoConstraints = false
        cell.NewColisQuantityTF.topAnchor.constraint(equalTo: cell.colisIcon.bottomAnchor, constant: 2).isActive = true
        cell.NewColisQuantityTF.leadingAnchor.constraint(equalTo: cell.colisIcon.leadingAnchor,constant: -5).isActive = true
        cell.NewColisQuantityTF.heightAnchor.constraint(equalToConstant: 25).isActive = true
        cell.NewColisQuantityTF.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //**************updateColisQuantityButton**************
        cell.updateColisQuantityButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.updateColisQuantityButton.tintColor = .white
        cell.updateColisQuantityButton.isUserInteractionEnabled = true
        cell.updateColisQuantityButton.layer.cornerRadius = 6.5
        cell.updateColisQuantityButton.setTitle("Update", for: .normal)
        cell.updateColisQuantityButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        cell.updateColisQuantityButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.updateColisQuantityButton.tintColor = .white
        //Layout Setup
        cell.updateColisQuantityButton.translatesAutoresizingMaskIntoConstraints = false
        cell.updateColisQuantityButton.centerXAnchor.constraint(equalTo: cell.NewColisQuantityTF.centerXAnchor).isActive = true
        cell.updateColisQuantityButton.topAnchor.constraint(equalTo: cell.NewColisQuantityTF.bottomAnchor, constant: 5).isActive = true
        cell.updateColisQuantityButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        cell.updateColisQuantityButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //**************ContainerViewLVCodeLabel**************
        cell.ContainerViewLVCodeLabel.textColor = .darkGray
        cell.ContainerViewLVCode = courses[indexPath.row].lettreDeVoiture!.code!
        cell.ContainerViewLVCodeLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(12))
        //Layout Setup
        cell.ContainerViewLVCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.ContainerViewLVCodeLabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -10).isActive = true
        cell.ContainerViewLVCodeLabel.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -10).isActive = true
        //**************observationsLabel**************
        cell.observationsLabel.textColor = .darkGray
        cell.observationsLabel.text = "Observations:"
        cell.observationsLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(14))
        //Layout Setup
        cell.observationsLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.observationsLabel.topAnchor.constraint(equalTo: cell.clientIcon.bottomAnchor, constant: -20).isActive = true
        cell.observationsLabel.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 10).isActive = true
        cell.observationsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //**************observationsTextView**************
        cell.observationsTextView.layer.borderWidth = 1
        cell.observationsTextView.layer.cornerRadius = 10
        cell.observationsTextView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.observationsTextView.contentInset = UIEdgeInsets(top: -5, left: 5, bottom: -5, right: 5)
        cell.observationsTextView.isEditable = false
        cell.observationsTextView.textColor = .darkGray
        if (courses[indexPath.row].observation == nil){
             cell.observationsTextView.text = ""
        }else{
            cell.observationsTextView.text = "\(courses[indexPath.row].observation!)"
        }
        cell.observationsTextView.font = UIFont(name: "Copperplate-Light", size: CGFloat(12))
        cell.observationsTextView.backgroundColor = .clear
        //Layout Setup
        cell.observationsTextView.translatesAutoresizingMaskIntoConstraints = false
        cell.observationsTextView.topAnchor.constraint(equalTo: cell.observationsLabel.bottomAnchor, constant: 0).isActive = true
        cell.observationsTextView.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 10).isActive = true
        cell.observationsTextView.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -10).isActive = true
        cell.observationsTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //**************CourseDetailsButton**************
        cell.CourseDetailsButton.layer.cornerRadius = 10
        cell.CourseDetailsButton.setTitle("More details", for: .normal)
        cell.CourseDetailsButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(15))
        cell.CourseDetailsButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        cell.CourseDetailsButton.tintColor = .white
        cell.CourseDetailsButton.addTarget(self, action: #selector(showCourseDetails(sender:)), for: .touchUpInside)
        cell.CourseDetailsButton.param = courses[indexPath.row].code!
        //Layout Setup
        cell.CourseDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        cell.CourseDetailsButton.topAnchor.constraint(equalTo: cell.observationsTextView.bottomAnchor, constant: 5).isActive = true
        cell.CourseDetailsButton.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 10).isActive = true
        cell.CourseDetailsButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -10).isActive = true
        cell.CourseDetailsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //**************stackView**************
        cell.ClientCallButton.contentMode = .scaleAspectFit
        cell.SAVCallButton.contentMode = .scaleAspectFit
        cell.LVDownloadButton.contentMode = .scaleAspectFit
        let tap1 = MyTapGesture(target: self, action: #selector(ClientCall(sender:)))
        let tap2 = MyTapGesture(target: self, action: #selector(SAVCall(sender:)))
        let tap3 = MyTapGesture(target: self, action: #selector(LVDownload(sender:)))
        // Fill param here
        tap1.param = courses[indexPath.row].commande!.client!.phone!
        tap2.param = "0182881887"
        tap3.param = "3"
        //-------
        cell.ClientCallButton.isUserInteractionEnabled = true
        cell.SAVCallButton.isUserInteractionEnabled = true
        cell.LVDownloadButton.isUserInteractionEnabled = true
        cell.ClientCallButton.addGestureRecognizer(tap1)
        cell.SAVCallButton.addGestureRecognizer(tap2)
        cell.LVDownloadButton.addGestureRecognizer(tap3)
        //Layout Setup
        cell.ButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        cell.ButtonStackView.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -15).isActive = true
        cell.ButtonStackView.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor).isActive = true
        cell.ButtonStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cell.ButtonStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    @objc func showCourseDetails(sender: MyButtonWithParam){
        print("showCourseDetails")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : CourseDetailsController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailsCourse") as! CourseDetailsController
        destViewController.toggleSideMenuView()
        destViewController.codeCourse = sender.param
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    @objc func ClientCall(sender: MyTapGesture){
        if let url = URL(string: "tel://\(sender.param)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        print("Calling : \(sender.param)")
    }
    @objc func SAVCall(sender: MyTapGesture){
        if let url = URL(string: "tel://\(sender.param)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        print("Calling : \(sender.param)")
    }
    @objc func LVDownload(sender: MyTapGesture){
        print("Calling : \(sender.param)")
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
        cell.adresseDepartLabel.backgroundColor = .clear
        cell.adresseArriveeLabel.backgroundColor = .clear
        cell.StatusAndDateLabel.textColor = .orange
        cell.LVcodeLabel.textColor = .darkGray
        //--------------------------------------
        //Layout Setup
        //**************departIcon**************
        cell.departIcon.translatesAutoresizingMaskIntoConstraints = false
         cell.departIcon.centerYAnchor.constraint(equalTo: cell.adresseDepartLabel.centerYAnchor).isActive = true
        cell.departIcon.trailingAnchor.constraint(equalTo: cell.adresseDepartLabel.leadingAnchor, constant: -IconHeightWidth/2).isActive = true
        cell.departIcon.heightAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        cell.departIcon.widthAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        //**************arriveeIcon**************
        cell.arriveeIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.arriveeIcon.centerYAnchor.constraint(equalTo: cell.adresseArriveeLabel.centerYAnchor).isActive = true
        cell.arriveeIcon.trailingAnchor.constraint(equalTo: cell.adresseArriveeLabel.leadingAnchor, constant: -IconHeightWidth/2).isActive = true
        cell.arriveeIcon.heightAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        cell.arriveeIcon.widthAnchor.constraint(equalToConstant: IconHeightWidth).isActive = true
        //**************StatusAndDate**************
        cell.StatusAndDateLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.StatusAndDateLabel.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset+2*labelHeight).isActive = true
        cell.StatusAndDateLabel.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.StatusAndDateLabel.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.StatusAndDateLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //**************adresseArrivee**************
        cell.adresseArriveeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.adresseArriveeLabel.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset + labelHeight).isActive = true
        cell.adresseArriveeLabel.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.adresseArriveeLabel.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.adresseArriveeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        //**************adresseDepart**************
        cell.adresseDepartLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.adresseDepartLabel.topAnchor.constraint(equalTo: cell.foregroundView.topAnchor, constant: topOffset).isActive = true
        cell.adresseDepartLabel.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset).isActive = true
        cell.adresseDepartLabel.leadingAnchor.constraint(equalTo: cell.foregroundView.leadingAnchor, constant: leadingOffset).isActive = true
        cell.adresseDepartLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        //**************LVcode**************
        cell.LVcodeLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.LVcodeLabel.bottomAnchor.constraint(equalTo: cell.foregroundView.bottomAnchor, constant: trailingOffset/3).isActive = true
        cell.LVcodeLabel.trailingAnchor.constraint(equalTo: cell.foregroundView.trailingAnchor, constant: trailingOffset/3).isActive = true

        //--------------------------------------
        //text Setup
        cell.LVCode = courses[indexPath.row].lettreDeVoiture!.code!
        //------
        cell.adresseDepart = courses[indexPath.row].adresseDepart!.address!
        //------
        cell.adresseArrivee = courses[indexPath.row].adresseArrivee!.address!
        //------
        let status = "\(courses[indexPath.row].status!.label!)"
        let deliveryWindow = courses[indexPath.row].dateDemarrageMeta!.deliveryWindow.value!
        let dateDemarrage = dateFormatter.date(from: courses[indexPath.row].dateDemarrage!)!
        let deadlineDate = Calendar.current.date(byAdding: .minute, value: deliveryWindow, to: dateDemarrage, wrappingComponents: false)!
        let yyyyMMdd = "\(Calendar.current.component(.day, from: dateDemarrage ))-\(Calendar.current.component(.month, from: dateDemarrage ))-\(Calendar.current.component(.year, from: dateDemarrage ))"
        let hour1 = "\(Calendar.current.component(.hour, from: dateDemarrage ))h"
        let hour2 = "\(Calendar.current.component(.hour, from: deadlineDate))h"
        cell.StatusAndDate = "\(status) : \(yyyyMMdd) entre \(hour1) et \(hour2)"
        //------
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        formatter.roundingMode = .up
//        cell.estimatedKM.text = "\(String(describing: formatter.string(from: NSNumber(value: courses[indexPath.row].estimatedKM))!)) Km"
    
        //--------------------------------------
        //Style Setup : https://github.com/lionhylra/iOS-UIFont-Names
        cell.adresseDepartLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.adresseArriveeLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.StatusAndDateLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))
        cell.LVcodeLabel.font = UIFont(name: "Copperplate-Light", size: CGFloat(12))
//        cell.estimatedKM.font = UIFont(name: "Copperplate-Light", size: CGFloat(17))
        //--------------------------------------
        //behaviour Setup
        cell.adresseDepartLabel.numberOfLines = 0
        cell.adresseArriveeLabel.numberOfLines = 0
        cell.StatusAndDateLabel.numberOfLines = 0
        cell.departIcon.contentMode = .scaleAspectFit
        cell.arriveeIcon.contentMode = .scaleAspectFit
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



