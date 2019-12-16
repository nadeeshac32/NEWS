//
//  ReactiveExtensiones.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}
extension Reactive where Base: UIViewController {
    var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}


extension News_V: gridListSwitchable {}
//extension UserPreferred_VC: gridListSwitchable {}

extension Reactive where Base: GenericViewController<News_V> {
    
    var isGridViewShown: Binder<Bool> {
        return Binder(self.base, binding: { (vc, isGridShown) in
            if isGridShown {
                vc.contentView.hideList()
                vc.contentView.showGrid()
//                vc.contentView.newsCollectionView.reloadData()
            } else {
                vc.contentView.hideGrid()
                vc.contentView.showList()
//                vc.contentView.newsTableView.reloadData()
            }
        })
    }
    
}
