//
//  ViewController.swift
//  GDEventBus
//
//  Created by Objc on 05/25/2020.
//  Copyright (c) 2020 Objc. All rights reserved.
//

import UIKit
import GDEventBus


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        self.view.addSubview(btn)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.present(TestViewController(), animated: true, completion: nil)
    }
    
    @objc func btnClick() {
        let event = JsonEvent()
        event.eventName = "test"
        dispatch(event)
    }

}

