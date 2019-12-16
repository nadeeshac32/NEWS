//
//  Profile_VC.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 17/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

class Profile_VC: GenericViewController<Profile_V>, UIGestureRecognizerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title           = "Profile"
    }
    
    
}
