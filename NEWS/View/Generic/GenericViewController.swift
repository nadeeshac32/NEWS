//
//  GenericViewController.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit

open class GenericViewController<View: GenericView>: UIViewController {
    open var contentView: View {
        return view as! View
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func loadView() {
        view = View(frame: UIScreen.main.bounds)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    open func configureView() {}
}
