//
//  TabBar_V.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 16/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import RxSwift

class TabBar_V: GenericView {
    
    private(set) var scrollView: UIScrollView = {
        $0.bounces                                  = false
        $0.isScrollEnabled                          = true
        return $0
    } (UIScrollView())
    
    private var tabButtons                          : [UIButton] = []
    let disposeBag                                  = DisposeBag()
    
    var viewModel                                   : TabBarViewModel? {
        didSet {
            self.viewModel?.buttonTitles
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (titles) in
                    self?.addButtonsToScrollView(titles: titles)
                })
                .disposed(by: disposeBag)
            
            self.viewModel?.selectedButtonIndex
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (tag) in
                    if let buttons = self?.tabButtons, buttons.count >= tag {
                        let button                     = buttons[tag]
                        button.setTitleColor(.white, for: .normal)
                        button.backgroundColor      = AppConfig.si.colorPrimary
                        button.layer.borderColor    = AppConfig.si.colorPrimary.cgColor
                        button.layer.borderWidth    = 2
                    }
                })
                .disposed(by: disposeBag)
            
            self.viewModel?.unselectedButtonIndex
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (tag) in
                    if let buttons = self?.tabButtons, buttons.count > tag {
                        let button                  = buttons[tag]
                        button.setTitleColor(#colorLiteral(red: 0.2195796371, green: 0.2196240723, blue: 0.2195768356, alpha: 1), for: .normal)
                        button.backgroundColor      = #colorLiteral(red: 0.9802859426, green: 0.9804533124, blue: 0.9802753329, alpha: 1)
                        button.layer.borderColor    = UIColor(hexString: "E3E3E3")?.cgColor
                        button.layer.borderWidth    = 2
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    override func configureView() {
        super.configureView()
        initializeUI()
        createConstraints()
        viewModel                                   = TabBarViewModel()
    }
    
    private func initializeUI() {
        self.backgroundColor                        = UIColor.white
        self.addSubview(scrollView)
    }
    
    private func createConstraints() {
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func addButtonsToScrollView(titles: [String]) {
        let scrollviewHeight                        = CGFloat(58)
        let buttonTopInsets                         = CGFloat(12)
        let buttonSideInsets                        = CGFloat(6)
        let buttonHeight                            = scrollviewHeight - (2 * buttonTopInsets)
        
        scrollView.contentSize.width                = 0
        scrollView.contentSize.height               = scrollviewHeight
        scrollView.removeAllSubViews()
        tabButtons.removeAll()
        
        let filtersTitles                           = titles.filter { (title) -> Bool in
            return title != ""
        }
        if filtersTitles.count > 0 {
            var index = CGFloat(0)
            for title in filtersTitles {
                
                let buttonWidth                     = title.width(constraintedHeight: buttonHeight, font: UIFont.systemFont(ofSize: 14)) + 20
                let button                          = UIButton(frame: CGRect(x: buttonSideInsets, y: buttonTopInsets, width: buttonWidth, height: buttonHeight))
                button.tag                          = Int(index)
                button.clipsToBounds                = true
                button.layer.cornerRadius           = buttonHeight / 2
                button.titleLabel?.font             = button.titleLabel?.font.withSize(14)
                button.setTitleColor(#colorLiteral(red: 0.2195796371, green: 0.2196240723, blue: 0.2195768356, alpha: 1), for: .normal)
                button.setTitle(title, for: .normal)
                button.backgroundColor              = #colorLiteral(red: 0.9802859426, green: 0.9804533124, blue: 0.9802753329, alpha: 1)
                button.layer.borderColor            = UIColor(hexString: "E3E3E3")?.cgColor
                button.layer.borderWidth            = 2
                button.addTarget(self, action: #selector(listBtnTapped(_:)), for: .touchUpInside)
                
                let buttonContainerWidth            = buttonWidth + (2 * buttonSideInsets)
                let buttonContainer                 = UIView(frame: CGRect(x: scrollView.contentSize.width, y: 0, width: buttonContainerWidth, height: scrollviewHeight))
                buttonContainer.addSubview(button)
                
                scrollView.contentSize.width        = scrollView.contentSize.width + buttonContainerWidth
                scrollView.addSubview(buttonContainer)
                tabButtons.append(button)
                index += 1
            }
        }
    }
    
    func highLightTabItemWith(index: Int) {
        viewModel?.itemTappedFor(index: index)
    }
    
    @objc func listBtnTapped(_ sender: UIButton) {
        highLightTabItemWith(index: sender.tag)
    }
}
