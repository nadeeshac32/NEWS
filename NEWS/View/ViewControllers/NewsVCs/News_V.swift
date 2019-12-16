//
//  News_V.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import SnapKit

class News_V: GenericView {
    
    private(set) var titleLabel: UILabel = {
        $0.textAlignment            = .left
        $0.textColor                = .black
        $0.font                     = UIFont.boldSystemFont(ofSize: 17)
        $0.text                     = ""
        return $0
    }(UILabel())
    
    private(set) var noOfResultsLabel: UILabel = {
        $0.textAlignment            = .left
        $0.textColor                = AppConfig.si.colorSubDetail
        $0.text                     = "0 results"
        return $0
    }(UILabel())
    
    private(set) var userSelectionTypeLabel: UILabel = {
        $0.textAlignment            = .left
        $0.font                     = UIFont.systemFont(ofSize: 12)
        $0.text                     = ""
        return $0
    }(UILabel())
    
    private(set) var userSelector: TabBar_V = {
        $0.clipsToBounds            = true
        return $0
    }(TabBar_V())
    
    private(set) var categoryLbl: UILabel = {
        $0.textAlignment            = .left
        $0.textColor                = .black
        $0.text                     = ""
        return $0
    }(UILabel())
    
    private(set) var gridBtn: UIButton = {
        let padding                 = CGFloat(5)
        $0.setTitle("", for: .normal)
        $0.contentEdgeInsets        = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        $0.setImage(UIImage(named: "grid_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor                = .black
        
        return $0
    }(UIButton())
    
    private(set) var listBtn: UIButton = {
        let padding                 = CGFloat(5)
        $0.setTitle("", for: .normal)
        $0.contentEdgeInsets        = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        $0.setImage(UIImage(named: "list_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor                = .black
        
        return $0
    }(UIButton())
    
    private(set) var newsTableView: UITableView = {
        $0.tableFooterView          = UIView(frame: CGRect.zero)
        $0.bounces                  = false
        $0.backgroundColor          = UIColor.clear
        $0.separatorStyle           = .none
        $0.rowHeight                = CGFloat(AppConfig.si.newsTVCellHeight)
        $0.register(News_TVCell.self, forCellReuseIdentifier: "News_TVCell")
        $0.isHidden                 = true
        return $0
    }(UITableView())
    
    private(set) var newsCollectionView: UICollectionView = {
        let cellSize                = AppConfig.si.newsCVCellSize
        let layout                  = UICollectionViewFlowLayout()
        layout.scrollDirection      = .vertical
        layout.itemSize             = cellSize
        layout.minimumLineSpacing   = 10.0
        layout.minimumInteritemSpacing  = 10.0
        $0.setCollectionViewLayout(layout, animated: true)
        $0.register(News_CVCell.self, forCellWithReuseIdentifier: "News_CVCell")
        $0.bounces                  = false
        $0.backgroundColor          = UIColor.clear
        $0.isHidden                 = true

        return $0
    } (UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout()))
    
    override func configureView() {
        super.configureView()
        initializeUI()
        createConstraints()
    }
    
    private func initializeUI() {
        self.backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(noOfResultsLabel)
        addSubview(userSelectionTypeLabel)
        addSubview(userSelector)
        addSubview(categoryLbl)
        addSubview(gridBtn)
        addSubview(listBtn)
        addSubview(newsTableView)
        addSubview(newsCollectionView)
    }
    
    private func createConstraints() {
        let sideMargin              = 30
        let verticleGap             = 12
        let horizontalGap           = 8
        let buttonHeight            = 44
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(sideMargin)
            make.right.equalToSuperview().inset(sideMargin)
            make.top.equalToSuperview().inset(100)
        }
        
        noOfResultsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(verticleGap)
        }
        
        userSelectionTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(noOfResultsLabel.snp.bottom).offset(verticleGap)
        }
        
        userSelector.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(sideMargin)
            make.right.equalToSuperview().inset(sideMargin)
            make.top.equalTo(userSelectionTypeLabel.snp.bottom)
            make.height.equalTo(60)
        }
        
        listBtn.snp.makeConstraints { (make) in
            make.width.equalTo(buttonHeight)
            make.height.equalTo(buttonHeight)
            make.right.equalToSuperview().inset(sideMargin)
            make.top.equalTo(userSelector.snp.bottom).offset(verticleGap)
        }
        
        gridBtn.snp.makeConstraints { (make) in
            make.width.equalTo(buttonHeight)
            make.height.equalTo(buttonHeight)
            make.right.equalTo(listBtn.snp.left).offset(-horizontalGap)
            make.centerY.equalTo(listBtn.snp.centerY)
        }
        
        categoryLbl.snp.makeConstraints { (make) in
            make.left.equalTo(sideMargin)
            make.centerY.equalTo(gridBtn.snp.centerY)
            make.right.greaterThanOrEqualTo(gridBtn.snp.left).offset(horizontalGap)
        }
        
        newsTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(listBtn.snp.bottom).offset(verticleGap)
            make.bottom.equalToSuperview()
        }
        
        newsCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(listBtn.snp.bottom).offset(verticleGap)
            make.bottom.equalToSuperview()
        }
    }
}
