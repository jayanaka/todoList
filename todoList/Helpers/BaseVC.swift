//
//  BaseVC.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseVC: UIViewController {
    
    var myBackgroundImage = UIImageView (frame: UIScreen.main.bounds);
    var networkErrorView: UIView?
    
    var activityIndicatorView: UIView?
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup network error view
        setUpNetworkErrorView()
        // Setup activity indicator view
        setUpActivityIndicatorView()
    }
    
    //MARK: - Progress
    func showProgress() {
        activityIndicatorView?.isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func hideProgress() {
        activityIndicatorView?.isHidden = true
        activityIndicator?.stopAnimating()
    }
    
    // hide Navigation Bar
    func hideNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    // keyboard hide
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Setup activity indicator view
    func setUpActivityIndicatorView() {
        activityIndicatorView = UIView(frame: self.view.bounds)
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView?.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

        let frame = CGRect(x: (self.view.frame.width - 60)/2, y: (self.view.frame.height - 60)/2, width: 60, height: 60)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator?.type = . ballScale
        activityIndicator?.color = UIColor.red
        
        activityIndicatorView!.addSubview(activityIndicator!)

        activityIndicatorView?.isHidden = true
        self.view.bringSubviewToFront(activityIndicatorView!)
        
    }
    
    // Setup network error view
    func setUpNetworkErrorView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let networkErrorVC = storyboard.instantiateViewController(withIdentifier: "NetworkErrorVC") as! NetworkErrorVC
        networkErrorVC.networkErrorMessageDelegate = self
        addChild(networkErrorVC)
        
        networkErrorView = UIView(frame: self.view.bounds)
        self.view.addSubview(networkErrorView!)

        networkErrorView!.addSubview((networkErrorVC.view)!)
        networkErrorVC.view.frame = networkErrorView!.bounds
        networkErrorVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        networkErrorVC.didMove(toParent: self)

        networkErrorView?.isHidden = true
        self.view.bringSubviewToFront(networkErrorView!)
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    // Show Network error view
    func showNetworkErrorView() {
        networkErrorView?.isHidden = false
    }
    
    // Hide Network error view
    func hideNetworkErrorView() {
        networkErrorView?.isHidden = true
    }
    
    // TryAgain network error view button Action
    func networkErrorTryAgainAction() {
    }
    
}

extension BaseVC: NetworkErrorMessageDelegate {
    func tryAgainAction() {
        networkErrorTryAgainAction()
    }
}

