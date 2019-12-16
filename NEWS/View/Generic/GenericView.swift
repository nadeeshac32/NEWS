//
//  GenericView.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import Toast_Swift

open class GenericView: UIView, ConfigurableView {
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public required init() {
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    open func configureView() {}
}
