//
//  LoadingViewable.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}
extension loadingViewable where Self : UIViewController {
    func startAnimating(){
        let activityView                    = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityView)
        activityView.restorationIdentifier  = "activityView"
        view.bringSubviewToFront(activityView)
        activityView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityView.startAnimating()
    }
    func stopAnimating() {
        for item in view.subviews
            where item.restorationIdentifier == "activityView" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}
