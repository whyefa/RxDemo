//
//  ViewController.swift
//  RxDemo
//
//  Created by 老王 on 2018/12/19.
//  Copyright © 2018 老王. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let param = ["location":"31.111111,114.222222", "key":"4YUBZ-QABK6-TR4SI-MJF6R-LW3GS-2VF3Q"]
        locationProvider.request(.location(param)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON()
                    let arr= Mapper<M>().mapArray(JSONObject:JSON(json).object)
                    successClosure(arr)
                } catch {
                    failClosure(self.failInfo)
                }
            case .failure(let err):
                print(err)
            }
        }
    }


}

