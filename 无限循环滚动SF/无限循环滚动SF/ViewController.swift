//
//  ViewController.swift
//  无限循环滚动SF
//
//  Created by yj on 2017/1/5.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var cycleView: YJCycleView = {
        let cycleV = YJCycleView.cycleView()
        cycleV.frame = CGRect(x:0, y:20 ,width:self.view.frame.size.width ,height:200.0)
        cycleV.dataArray = ["IMG_0","IMG_1","IMG_2","IMG_3"]
        return cycleV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cycleView.backgroundColor = UIColor.red
        view.addSubview(cycleView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

