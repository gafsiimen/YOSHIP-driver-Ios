//
//  MonHistoriqueViewController.swift
//  Box2HomeDriver
//
//  Created by MacHD on 5/31/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import UIKit

class MonHistoriqueViewController: UIViewController {
    var courses : [Course] = []
    let viewModel = MonHistoriqueViewModel(MonHistoriqueRepository: MonHistoriqueRepository())

    override func viewDidLoad() {
        super.viewDidLoad()
       courses = viewModel.GetHistory()
    }
    

    
}
