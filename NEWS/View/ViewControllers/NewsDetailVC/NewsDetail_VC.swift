//
//  NewsDetail_VC.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

class NewsDetail_VC: GenericViewController<NewsDetail_V>, UIGestureRecognizerDelegate {
    
    lazy var viewModel: NewsDetailViewModel = {
        $0.updateTitle = { [weak self] (title: String) in
            self?.navigationItem.title       = title
        }
        return $0
    }(NewsDetailViewModel())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title           = ""
        self.viewModel.viewWillAppear()
    }
    
    
}
