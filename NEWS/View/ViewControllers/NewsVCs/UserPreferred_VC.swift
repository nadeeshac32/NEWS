//
//  UserPreferred_VC.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 17/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserPreferred_VC: GenericViewController<News_V> {
    
    let disposeBag = DisposeBag()
    lazy var viewModel: NewsViewModel = {
        self.bindViewModel(viewModel: $0)
        return $0
    } (NewsViewModel(httpService: HTTPService()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title                                           = "NEWS API"
    }
    
    override func configureView() {
        contentView.newsTableView.delegate                                  = self
        contentView.newsCollectionView.delegate                             = self
        contentViewViewModelBinding()
        viewModel.initialLoading()
    }
    
}

extension UserPreferred_VC {
    func bindViewModel(viewModel: NewsViewModel) {
        
        viewModel.loadingArticles.asObservable()
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message) in
                self?.contentView.makeToast(message)
            })
            .disposed(by: disposeBag)
        
        viewModel.basicDetails
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (basicDetail) in
                self?.contentView.userSelector.viewModel?.titlesArray   = basicDetail.selectorKeywords
                self?.contentView.userSelectionTypeLabel.text           = basicDetail.selectorType
                self?.contentView.titleLabel.text                       = basicDetail.title
            })
            .disposed(by: disposeBag)
        
        viewModel.initiallySelectedTabBarIndex
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (initalIndex) in
                self?.contentView.userSelector.highLightTabItemWith(index: initalIndex)
            })
            .disposed(by: disposeBag)
        
        viewModel.isShowingGridView
            .bind(to: self.rx.isGridViewShown)
            .disposed(by: disposeBag)
        
        viewModel.detailsForSelectedKeywords
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (basicDetails) in
                self?.contentView.noOfResultsLabel.text                     = basicDetails.noOfResultsText
                self?.contentView.categoryLbl.text                          = basicDetails.selectedKeyword
                
            })
            .disposed(by: disposeBag)
        
        viewModel.articlesCollection.asObservable().bind(to: contentView.newsCollectionView.rx.items(cellIdentifier: "News_CVCell", cellType: News_CVCell.self)) {  (row, article, cell) in
            cell.viewModel?.article = article
            }
            .disposed(by: disposeBag)
        
        viewModel.articlesCollection.asObservable().bind(to: contentView.newsTableView.rx.items(cellIdentifier: "News_TVCell", cellType: News_TVCell.self)) {  (row, article, cell) in
            cell.viewModel?.article = article
            }
            .disposed(by: disposeBag)
    }
    
    func contentViewViewModelBinding() {
        contentView.gridBtn.rx.tap
            .bind(onNext: viewModel.gridBtnTapped)
            .disposed(by: disposeBag)
        
        contentView.listBtn.rx.tap
            .bind(onNext: viewModel.listBtnTapped)
            .disposed(by: disposeBag)
        
        contentView.userSelector.viewModel?.selectedButtonTitle
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (selectedKeyword) in
                self?.viewModel.selectKeyword(keyword: selectedKeyword)
            })
            .disposed(by: disposeBag)
        
        contentView.newsTableView.rx
            .modelSelected(Article.self)
            .subscribe(onNext: { [weak self] (article) in
                let newsDetailVC                                            = NewsDetail_VC()
                newsDetailVC.viewModel.article                              = article
                if let navigator = self?.navigationController {
                    navigator.pushViewController(newsDetailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        contentView.newsCollectionView.rx
            .modelSelected(Article.self)
            .subscribe(onNext: { [weak self] (article) in
                let newsDetailVC                                            = NewsDetail_VC()
                newsDetailVC.viewModel.article                              = article
                if let navigator = self?.navigationController {
                    navigator.pushViewController(newsDetailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
}

extension UserPreferred_VC: UICollectionViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat     = 100
        let bottomEdge          = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            viewModel.loadArticles()
        }
    }
}
