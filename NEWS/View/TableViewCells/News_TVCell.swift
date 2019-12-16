//
//  News_TVCell.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class News_TVCell: GenericTableViewCell {
    
    private(set) var newsImage: UIImageView = {
        $0.backgroundColor          = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        $0.layer.cornerRadius       = 5
        $0.clipsToBounds            = true
        $0.tintColor                = .lightGray
        $0.contentMode              = .scaleToFill
        return $0
    }(UIImageView(frame: CGRect.zero))
    
    private(set) var navigateBtn: UIButton = {
        let padding                 = CGFloat(5)
        $0.setTitle("", for: .normal)
        $0.contentEdgeInsets        = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        $0.setImage(UIImage(named: "right_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor                = .black
        
        return $0
    }(UIButton())
    
    private(set) var titleLbl: UITextView = {
        $0.textAlignment            = .left
        $0.tintColor                = AppConfig.si.colorPrimary
        $0.isUserInteractionEnabled = true
        $0.isEditable               = false
        $0.isScrollEnabled          = false
        $0.textContainerInset       = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
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
                .subscribe(onNext: { [weak self] (article) in
                    self?.newsImage.image           = UIImage(named: AppConfig.si.default_ImageName)?.withRenderingMode(.alwaysTemplate)
                    self?.newsImage.setImageWith(imagePath: article.uuid)
                    self?.titleLbl.attributedText   = article.title
                    self?.descLbl.text              = article.desc
                    self?.authorLbl.text            = article.author
                    //  self?.orginalPost.url       = article.linkToOrginalNews
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func configureView() {
        super.configureView()
        selectionStyle              = .none
        initializeUI()
        createConstraints()
        viewModel                   = NewsCellViewModel()
    }
    
    private func initializeUI() {
        addSubview(newsImage)
        addSubview(navigateBtn)
        addSubview(titleLbl)
        addSubview(descLbl)
        addSubview(authorLbl)
    }
    
    private func createConstraints() {
        let cellHeight              = AppConfig.si.newsTVCellHeight
        let imageWidth              = 120
        
        let topMargin               = 8
        let sideMargin              = 12
        let verticleGap             = 5
        let horizontalGap           = 12
        
        let buttonHeight            = 44
        
        let topAndBottomOffset      = 12
        let labelHeight             = (cellHeight - (2 * topAndBottomOffset) - (2 * topMargin) - (2 * verticleGap)) / 3
        
        
        newsImage.snp.makeConstraints { (make) in
            make.width.equalTo(imageWidth)
            make.height.equalTo(cellHeight - (2 * topMargin))
            make.left.equalToSuperview().inset(sideMargin)
            make.top.equalToSuperview().inset(topMargin)
            make.bottom.equalToSuperview().inset(topMargin)
        }
        
        navigateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(newsImage.snp.centerY)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonHeight)
            make.right.equalToSuperview().inset(sideMargin)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(newsImage.snp.right).offset(horizontalGap)
            make.top.equalTo(newsImage.snp.top).offset(topAndBottomOffset)
            make.height.equalTo(labelHeight)
            make.right.equalTo(navigateBtn.snp.left).offset(-horizontalGap)
        }
        
        descLbl.snp.makeConstraints { make in
            make.left.equalTo(titleLbl.snp.left)
            make.top.equalTo(titleLbl.snp.bottom).offset(verticleGap)
            make.height.equalTo(labelHeight)
            make.right.equalTo(titleLbl.snp.right)
        }
        
        authorLbl.snp.makeConstraints { make in
            make.left.equalTo(titleLbl.snp.left)
            make.top.equalTo(descLbl.snp.bottom).offset(verticleGap)
            make.height.equalTo(labelHeight)
            make.right.equalTo(titleLbl.snp.right)
        }
    }
    
}
