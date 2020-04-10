//
//  ViewController.swift
//  GradientButton
//
//  Created by cg on 2020/4/10.
//  Copyright © 2020 df. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let itemBtn = GradientButton.init(title: "Submit",
                                          colors: [colorWithHexString("#F38543"),colorWithHexString("#FFC070")],
                                          direction: .Horizontal) { isSelected,btn in
        }
        itemBtn.frame = CGRect(x: 30, y: 100, width: kScreenWidth - 60, height: 35)
        view.addSubview(itemBtn)
    }


}

