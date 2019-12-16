//
//  NewsViewModel.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 17/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class NewsViewModel: NSObject {
    
    var httpService                         : HTTPService!
    let isShowingGridView                   : PublishSubject<Bool> = PublishSubject()
    let toastMessage                        : PublishSubject<String> = PublishSubject()
    
    let basicDetails                        : PublishSubject<(title: String, selectorKeywords: [String], selectorType: String)> = PublishSubject()
    var keywords                            : [String]  = []
    var selectedKeywords                    : String    = ""
    let detailsForSelectedKeywords          : PublishSubject<(selectedKeyword: String, noOfResultsText: String)> = PublishSubject()
    let initiallySelectedTabBarIndex        : PublishSubject<Int> = PublishSubject<Int>()
    
    var pageNumber                          : Int = 1
    var articlesCollection                  : Variable<[Article]> = Variable([])
    var loadingArticles                     : Variable<Bool> = Variable(false)
    var pageLoadFinished                    : Variable<Bool> = Variable(false)
    
    
    init(httpService: HTTPService, scheduler: SchedulerType? = nil) {
        super.init()
        self.httpService                    = httpService
    }
    
    func gridBtnTapped() {
        isShowingGridView.onNext(true)
    }
    
    func listBtnTapped() {
        isShowingGridView.onNext(false)
    }
    
    func initialLoading() {
        self.keywords.append("bitcoin")
        self.keywords.append("apple")
        self.keywords.append("earthquake")
        self.keywords.append("animal")
        self.basicDetails.onNext((title: "User Preferred", selectorKeywords: self.keywords, selectorType: "Keywords:"))
        self.basicDetails.onCompleted()
        self.basicDetails.dispose()
        
        self.initiallySelectedTabBarIndex.onNext(0)
        self.initiallySelectedTabBarIndex.onCompleted()
        self.initiallySelectedTabBarIndex.dispose()
        
        self.selectKeyword(keyword: self.keywords.first!)
        self.isShowingGridView.onNext(true)
    }
    
    func selectKeyword(keyword: String) {
        self.selectedKeywords               = keyword
        self.articlesCollection.value.removeAll()
        self.pageNumber                     = 1
        self.loadingArticles.value          = false
        self.pageLoadFinished.value         = false
        self.detailsForSelectedKeywords.onNext((selectedKeyword: self.selectedKeywords, noOfResultsText: "0 results"))
        
        loadArticles()
    }
    
    func loadArticles() {
        guard !loadingArticles.value, !pageLoadFinished.value else { return }
        let batchSize                       = AppConfig.si.dataBatchSize
        let httpService                     = HTTPService()
        self.loadingArticles.value          = true
        
        httpService.getEveryNews(qInTitle: self.selectedKeywords, pageSize: batchSize, page: self.pageNumber, onSuccess: { [weak self] (articles) in
            self?.articlesCollection.value.append(contentsOf: articles)
            self?.pageNumber                = self?.pageNumber ?? 0 + 1
            self?.loadingArticles.value     = false
            self?.pageLoadFinished.value    = articles.count < batchSize
            self?.detailsForSelectedKeywords.onNext((selectedKeyword: self?.selectedKeywords ?? "", noOfResultsText: "\(self?.articlesCollection.value.count ?? 0) results"))
            
        }) { [weak self] (error) in
            self?.loadingArticles.value = false
            //  self?.articlesCollection.value.removeAll()
            switch error {
            case .ServerError(_, let errorMsg):
                self?.toastMessage.onNext(errorMsg)
                return
            default:
                break
            }
            print("error: \(error)")
            self?.toastMessage.onNext("Something went wrong")
        }
    }
}
