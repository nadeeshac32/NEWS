//
//  NewsCellViewModel.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class NewsCellViewModel: NSObject {
    
    var article: Article? {
        didSet {
            let imageUrl                = article?.urlToImage ?? ""
            let title                   = article?.title ?? ""
            let desc                    = article?.description ?? ""
            let author                  = article?.author ?? ""
            let linkToOrginalPost       = article?.url ?? ""
            
            let titleAttributedString = NSMutableAttributedString(string: title)
            titleAttributedString.addAttribute(NSAttributedString.Key.link, value: linkToOrginalPost, range: NSRange(location: 0, length: title.count - 1))
            titleAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: AppConfig.si.colorPrimary, range: NSRange(location: 0, length: title.count - 1))
            titleAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: title.count - 1))
            
            articleDetail.onNext((titleAttributedString, desc, author, imageUrl, linkToOrginalPost))
        }
    }
    
    public let articleDetail: PublishSubject<(title: NSMutableAttributedString, desc : String, author: String, uuid: String, linkToOrginalNews: String)> = PublishSubject()
}
