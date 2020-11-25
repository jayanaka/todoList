//
//  ToDoDetailVC.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit
import SimpleCheckbox
import Alamofire

class ToDoDetailVC: BaseVC {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var checkBox: Checkbox!
    
    var isAddToDo: Bool = true
    var todoItem: Todo?
    var todoIndexPath: IndexPath?
    
    var delegate: ToDoItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        setUpUi()
    }
    
    func setUpUi() {
        btnSubmit.layer.cornerRadius = 5.0
        
        txtTitle.layer.borderColor = UIColor.lightGray.cgColor
        txtTitle.layer.borderWidth = 1.0
        txtTitle.layer.cornerRadius = 5.0
        
        checkBox.borderStyle = .square
        checkBox.checkedBorderColor = UIColor.init(hexString: Common.themeColor)
        checkBox.checkmarkColor = UIColor.init(hexString: Common.themeColor)
        checkBox.borderCornerRadius = 5.0
        checkBox.checkmarkSize = 0.6
        checkBox.uncheckedBorderColor = .gray
        checkBox.checkmarkStyle = .tick
        
        if isAddToDo {
            btnSubmit.setTitle("Add", for: .normal)
        } else {
            btnSubmit.setTitle("Update", for: .normal)
            txtTitle.text = todoItem?.title ?? ""
            checkBox.isChecked = todoItem?.completed ?? false
        }
        
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty else {
            Common.showMessage(type: Common.ErrorMessage, title: "Error", message: "Title field cannot be empty.")
            return
        }
        if isAddToDo {
            addToDoItem()
        } else {
            updateToDoItem()
        }
        
    }
    
    func addToDoItem() {
        if !(NetworkReachabilityManager()?.isReachable)! {
                    showNetworkErrorView()
                    
        } else {
            let parameters: Parameters = [
                "userId": 1,
                "title": txtTitle.text ?? "",
                "completed": checkBox.isChecked
            ]
            
            let todoService = ToDoService()
            self.showProgress()
            todoService.addTodoListItem(parameters: parameters, onSuccess: { (response: Todo) -> Void in
                self.hideProgress()
                self.delegate?.addToDoItemToList(todoItem: response)
                self.backButtonPressed()

            }, onResponseError: { (error: String, status: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)

            }, onError: { (error: String, code: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)

            })
        }
    }
    
    func updateToDoItem() {
        if !(NetworkReachabilityManager()?.isReachable)! {
            showNetworkErrorView()
            
        } else {
            let parameters: Parameters = [
                "userId": todoItem?.userId ?? 1,
                "title": txtTitle.text ?? "",
                "completed": checkBox.isChecked
            ]
            
            let todoService = ToDoService()
            self.showProgress()
            todoService.updateTodoListItem(todoId: todoItem?.id ?? 0, parameters: parameters, onSuccess: { (response: Todo) -> Void in
                self.hideProgress()
                self.delegate?.updateToDoItemInList(todoItem: response, index: self.todoIndexPath!)
                self.backButtonPressed()

            }, onResponseError: { (error: String, status: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)

            }, onError: { (error: String, code: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)

            })
        }
    }
    
    override func networkErrorTryAgainAction() {
        hideNetworkErrorView()
        if isAddToDo {
            addToDoItem()
        } else {
            updateToDoItem()
        }
        
    }
    
}
