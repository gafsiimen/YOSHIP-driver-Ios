//
//  CollectionViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/22/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var dataArray: [Data] = []
    var codeCourse:String = "" {
        didSet{
            let course = SessionManager.currentSession.allCourses.filter() { $0.code == self.codeCourse }[0]
            self.dataArray = Array(course.colisImagesData)
        }
    }

    @objc func goBackButton(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : CourseDetailsController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailsCourse") as! CourseDetailsController
        destViewController.codeCourse = self.codeCourse
        destViewController.toggleSideMenuView()
        sideMenuController()?.setContentViewController(contentViewController: destViewController)
    }
    
   
    fileprivate func setupBackButton() {
        backButton.setTitle("Retour", for: .normal)
        backButton.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 1)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont(name: "Copperplate-Light", size: CGFloat(13))!
        backButton.layer.cornerRadius = 10
        backButton.alpha = 1
        backButton.addTarget(self, action: #selector(goBackButton), for: .touchUpInside)
    }
    
    func setupView(){
        self.view.backgroundColor = UIColor(displayP3Red: (43/255), green: 155/255, blue: 205/255, alpha: 0.5)
        backButton.tintColor = .white
        setupBackButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    
}
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(data: dataArray[indexPath.row])
        cell.index.text = "\(indexPath.row)"
        cell.index.font = UIFont(name: "Copperplate-Light", size: CGFloat(16))
        return cell
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.3) {
//            self.backButton.alpha = 0.3
//        }
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        UIView.animate(withDuration: 0.3) {
//            self.backButton.alpha = 1
//        }
//    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
  
}
