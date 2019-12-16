//
//  NewsDetailViewModel.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

class NewsDetailViewModel: NSObject {
    var article: Article?
    var updateTitle              : ((_ title: String) -> Void)?
    
    func viewWillAppear() {
        if let artitleTitle               = article?.title {
            updateTitle?(artitleTitle)
        }
    }
}
