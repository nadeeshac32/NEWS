//
//  GridListSwitchable.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

protocol gridListSwitchable {
    func showGrid()
    func hideGrid()
    func showList()
    func hideList()
}

extension gridListSwitchable where Self: News_V {
    
    func showGrid() {
        self.newsCollectionView.isHidden        = false
        self.bringSubviewToFront(self.newsCollectionView)
        UIView.animate(withDuration: 0.3, animations: {
            self.gridBtn.tintColor              = AppConfig.si.colorPrimary
            self.newsCollectionView.alpha       = 1
            self.newsCollectionView.reloadData()
        })
    }
    
    func hideGrid() {
        UIView.animate(withDuration: 0.3, animations: {
            self.newsCollectionView.alpha       = 0
            self.gridBtn.tintColor              = .black
        }) { (_) in
            self.newsCollectionView.isHidden    = true
            self.sendSubviewToBack(self.newsCollectionView)
        }
    }
    
    func showList() {
        self.newsTableView.isHidden         = false
        self.bringSubviewToFront(self.newsTableView)
        UIView.animate(withDuration: 0.3, animations: {
            self.listBtn.tintColor          = AppConfig.si.colorPrimary
            self.newsTableView.alpha        = 1
            self.newsTableView.reloadData()
        })
    }
    
    func hideList() {
        UIView.animate(withDuration: 0.3, animations: {
            self.newsTableView.alpha        = 0
            self.listBtn.tintColor          = .black
        }) { (_) in
            self.newsTableView.isHidden     = true
            self.sendSubviewToBack(self.newsTableView)
        }
    }
}

