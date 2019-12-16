//
//  News_CVCell.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class News_CVCell: GenericCollectionViewCell {
    
    private(set) var newsImage: UIImageView = {
        $0.backgroundColor          = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.layer.cornerRadius       = 5
        $0.clipsToBounds            = true
        $0.tintColor                = .lightGray
        $0.contentMode              = .scaleToFill
        return $0
    }(UIImageView(frame: CGRect.zero))
    
    private(set) var titleLbl: UITextView = {
        $0.textAlignment            = .left
        $0.tintColor                = AppConfig.si.colorPrimary
        $0.isUserInteractionEnabled = true
        $0.isEditable               = false
        $0.isScrollEnabled          = false
        $0.textContainerInset       = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.text                     = ""
        return $0
    }(UITextView())
    
    private(set) var descLbl: UILabel = {
        $0.textAlignment            = .left
        $0.textColor                = .black
        $0.font                     = UIFont.boldSystemFont(ofSize: 15)
        $0.text                     = ""
        return $0
    }(UILabel())
    
    private(set) var authorLbl: UILabel = {
        $0.textAlignment            = .left
        $0.textColor                = .black
        $0.font                     = UIFont.systemFont(ofSize: 14)
        $0.text                     = ""
        return $0
    }(UILabel())
    
    let disposeBag                  = DisposeBag()
    
    var viewModel                   : NewsCellViewModel? {
        didSet {
            self.viewModel?.articleDetail
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (newsDetail) in
                    self?.newsImage.image           = UIImage(named: AppConfig.si.default_ImageName)?.withRenderingMode(.alwaysTemplate)
                    self?.newsImage.setImageWith(imagePath: newsDetail.uuid)
                    self?.titleLbl.attributedText   = newsDetail.title
                    self?.descLbl.text              = newsDetail.desc
                    self?.authorLbl.text            = newsDetail.author
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func configureView() {
        super.configureView()
        initializeUI()
        createConstraints()
        viewModel                   = NewsCellViewModel()
    }
    
    private func initializeUI() {
        addSubview(newsImage)
        addSubview(titleLbl)
        addSubview(descLbl)
        addSubview(authorLbl)
    }
    
    private func createConstraints() {
        let cellHeight              = 340
        
        let topMargin               = 8
        let sideMargin              = 20
        let verticleGap             = 0
        
        let sideOffsetToImage       = 5
        let topOffsetToImage        = 12
        let labelHeight             = 20
        let imageHeight             = cellHeight - topMargin - (2 * topOffsetToImage) - (2 * verticleGap) - (3 * labelHeight)
        
        newsImage.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(sideMargin)
            make.height.equalTo(imageHeight)
            make.top.equalToSuperview().inset(topMargin)
            make.left.equalToSuperview().inset(sideMargin)
            make.right.equalToSuperview().inset(sideMargin)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(newsImage.snp.bottom).offset(topOffsetToImage)
            make.height.equalTo(labelHeight)
            make.left.equalTo(newsImage.snp.left).offset(sideOffsetToImage)
            make.right.equalTo(newsImage.snp.right).offset(-sideOffsetToImage)
        }
        
        descLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(verticleGap)
            make.height.equalTo(labelHeight)
            make.left.equalTo(titleLbl.snp.left)
            make.right.equalTo(titleLbl.snp.right)
        }
        
        authorLbl.snp.makeConstraints { make in
            make.top.equalTo(descLbl.snp.bottom).offset(verticleGap)
            make.height.equalTo(labelHeight)
            make.left.equalTo(descLbl.snp.left)
            make.right.equalTo(descLbl.snp.right)
        }
        
    }
    
}

