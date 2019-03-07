//
//  NavigationController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 2/19/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class NavigationController: ENSideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: SideMenuViewController(), menuPosition:.Left)
//        view.bringSubviewToFront(navigationBar)
    }
}
