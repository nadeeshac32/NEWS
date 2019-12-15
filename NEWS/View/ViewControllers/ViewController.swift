//
//  ViewController.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 14/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let httpService = HTTPService()
        httpService.getTopHeadlines(q: "something", pageSize: 10, page: 1, onSuccess: { (articles) in
            print("articles: \(articles)")
        }) { (error) in
            print("error: \(error)")
        }
    }


}

