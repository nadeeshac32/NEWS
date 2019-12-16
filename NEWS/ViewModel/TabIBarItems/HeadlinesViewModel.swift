//
//  HeadlinesViewModel.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class HeadlinesViewModel: NSObject {
    
    var httpService                         : HTTPService!
    let isShowingGridView                   : PublishSubject<Bool> = PublishSubject()
    let toastMessage                        : PublishSubject<String> = PublishSubject()
    
    let basicDetails                        : PublishSubject<(title: String, selectorCategories: [String], selectorType: String)> = PublishSubject()
    var categories                          : [String]  = []
    var selectedCategory                    : String    = ""
    let detailsForSelectedCategory          : PublishSubject<(selectedCategory: String, noOfResultsText: String)> = PublishSubject()
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
        self.categories.append("business")
        self.categories.append("entertainment")
        self.categories.append("general")
        self.categories.append("health")
        self.categories.append("science")
        self.categories.append("sports")
        self.categories.append("technology")
        self.basicDetails.onNext((title: "Top Headlines", selectorCategories: self.categories, selectorType: "Categories:"))
        self.basicDetails.onCompleted()
        self.basicDetails.dispose()
        
        self.initiallySelectedTabBarIndex.onNext(0)
        self.initiallySelectedTabBarIndex.onCompleted()
        self.initiallySelectedTabBarIndex.dispose()
        
        self.selectCategory(category: self.categories.first!)
        self.isShowingGridView.onNext(true)
    }
    
    func selectCategory(category: String) {
        self.selectedCategory               = category
        self.articlesCollection.value.removeAll()
        self.pageNumber                     = 1
        self.detailsForSelectedCategory.onNext((selectedCategory: self.selectedCategory, noOfResultsText: "0 results"))
        
        loadArticles()
    }
    
    func loadArticles() {
        guard !loadingArticles.value, !pageLoadFinished.value else { return }
        let batchSize                       = AppConfig.si.dataBatchSize
        let httpService                     = HTTPService()
        self.loadingArticles.value          = true
        
        httpService.getTopHeadlines(category: self.selectedCategory, pageSize: batchSize, page: self.pageNumber, onSuccess: { [weak self] (articles) in
            self?.articlesCollection.value.append(contentsOf: articles)
            self?.pageNumber                = self?.pageNumber ?? 0 + 1
            self?.loadingArticles.value     = false
            self?.pageLoadFinished.value    = articles.count < batchSize
            self?.detailsForSelectedCategory.onNext((selectedCategory: self?.selectedCategory ?? "", noOfResultsText: "\(self?.articlesCollection.value.count ?? 0) results"))
            
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
