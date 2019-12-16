//
//  TabBarViewModel.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class TabBarViewModel: NSObject {
    
    var titlesArray: [String]? {
        didSet {
            if let titles = titlesArray {
                buttonTitles.onNext(titles)
            }
        }
    }
    
    let buttonTitles                        : PublishSubject<[String]> = PublishSubject()
    let selectedButtonTitle                 : PublishSubject<String> = PublishSubject()
    let selectedButtonIndex                 : PublishSubject<Int> = PublishSubject()
    let unselectedButtonIndex               : PublishSubject<Int> = PublishSubject()
    
    func itemTappedFor(index: Int) {
        if let titles = titlesArray {
            selectedButtonTitle.onNext(titles[index])
            
            Range(0...titles.count - 1).filter { $0 != index }.forEach { (indexofBtnShouldBeDefault) in
                unselectedButtonIndex.onNext(indexofBtnShouldBeDefault)
            }
            selectedButtonIndex.onNext(index)
        }
        
        
    }
}

