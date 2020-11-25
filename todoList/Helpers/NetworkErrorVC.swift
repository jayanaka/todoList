//
//  NetworkErrorVC.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit

protocol NetworkErrorMessageDelegate {
    func tryAgainAction()
}

class NetworkErrorVC: UIViewController {
    
    @IBOutlet weak var btnRetry: UIButton!
    
    var networkErrorMessageDelegate: NetworkErrorMessageDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRetry.layer.cornerRadius = 5.0
    }

    @IBAction func tryAgainButtonAction(_ sender: Any) {
        self.networkErrorMessageDelegate.tryAgainAction()
        
    }
    
}
