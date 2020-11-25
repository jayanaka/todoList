//
//  ToDoListVC.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit
import Alamofire

class ToDoListVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lblTaskCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    var todoList: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        getToDoList()
    }
    
    func setupUi() {
        // tableview
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableView.automaticDimension
        
        //add button
        btnAdd.layer.cornerRadius = 25.0
        
        // set date
        let (weekDay, day, month) = Common.getDateValues()
        lblMonth.text = month
        lblDate.attributedText = Common.createAttributedStringBold(textNormal: day, textBold: "\(weekDay), ", fontSize: 24.0)
        
    }
  
        
    func getToDoList() {
        
        if !(NetworkReachabilityManager()?.isReachable)! {
            showNetworkErrorView()
            
        } else {
            
            let todoService = ToDoService()
            self.showProgress()
            todoService.getTodoList(onSuccess: { (response: [Todo]) -> Void in
                self.hideProgress()
                self.todoList = response
                self.tableView.reloadData()
                self.updateTaskCount()

            }, onResponseError: { (error: String, status: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            }, onError: { (error: String, code: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            })
        }
    }
    
    func updateStatusToDoListItem(isCheck: Bool, todoItem: Todo, indexPath: IndexPath) {
        
        if !(NetworkReachabilityManager()?.isReachable)! {
            showNetworkErrorView()
            
        } else {
            let parameters: Parameters = [
                "userId": todoItem.userId ?? 1,
                "title": todoItem.title ?? "",
                "completed": isCheck
            ]
            
            let todoService = ToDoService()
            self.showProgress()
            todoService.updateTodoListItem(todoId: todoItem.id ?? 0, parameters: parameters, onSuccess: { (response: Todo) -> Void in
                self.hideProgress()
                self.todoList[indexPath.row] = response
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.updateTaskCount()

            }, onResponseError: { (error: String, status: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            }, onError: { (error: String, code: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            })
        }
    }
    
    func deleteToDoListItem(id: Int, indexPath: IndexPath) {
        
        if !(NetworkReachabilityManager()?.isReachable)! {
            showNetworkErrorView()
            
        } else {
            
            let todoService = ToDoService()
            self.showProgress()
            todoService.deleteTodoListItem(todoId: id, onSuccess: { (response: Bool) -> Void in
                self.hideProgress()
                self.tableView.beginUpdates()
                self.todoList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                self.updateTaskCount()

            }, onResponseError: { (error: String, status: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            }, onError: { (error: String, code: Int) -> Void in
                print(error)
                self.hideProgress()
                self.showAlert(title: "Error", message: error)
                self.updateTaskCount()

            })
        }
    }
    
    func updateTaskCount() {
        lblTaskCount.attributedText = Common.createAttributedStringBold(textNormal: todoList.count > 1 ? " Tasks" : todoList.count > 1 ? " Task" : "No Tasks", textBold: todoList.count > 0 ? "\(todoList.count)" : "", fontSize: 18.0)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "ToDoDetailVC") as! ToDoDetailVC
        detailVC.delegate = self
        detailVC.title = "Add Todo Item"
        detailVC.isAddToDo = true
        let navigationVC = UINavigationController(rootViewController: detailVC)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true, completion: nil)
        
    }
    
    override func networkErrorTryAgainAction() {
        hideNetworkErrorView()
        getToDoList()
        
    }
    
    func deleteToDoFunc(indexPath: IndexPath) {
        deleteToDoListItem(id: todoList[indexPath.row].id ?? 0, indexPath: indexPath)
    }
    
    func editToDoFunc(indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "ToDoDetailVC") as! ToDoDetailVC
        detailVC.delegate = self
        detailVC.title = "Update Todo Item"
        detailVC.isAddToDo = false
        detailVC.todoItem = todoList[indexPath.row]
        detailVC.todoIndexPath = indexPath
        let navigationVC = UINavigationController(rootViewController: detailVC)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true, completion: nil)
    }
        
}

// MARK: - Table View DataSource
extension ToDoListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListTVC", for: indexPath) as! ToDoListTVC
        let todo = todoList[indexPath.row]
        cell.delegate = self
        cell.todoItem = todo
        cell.index = indexPath
        cell.lblTitle.text = todo.title ?? ""
        cell.checkBox.isChecked = todo.completed ?? false

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todo.title ?? "")
        if todo.completed ?? false {
            cell.lblTitle.textColor = .lightGray
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        } else {
            cell.lblTitle.textColor = .gray
        }
        cell.lblTitle.attributedText = attributeString
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Table View Delegate
extension ToDoListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.deleteToDoFunc(indexPath: indexPath)
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.editToDoFunc(indexPath: indexPath)
        }

        return [edit, delete]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ToDoListVC: ToDoItemDelegate {
    func addToDoItemToList(todoItem: Todo) {
        self.todoList.insert(todoItem, at: 0)
        self.tableView.reloadData()
        self.updateTaskCount()
    }
    
    func updateToDoItemInList(todoItem: Todo, index: IndexPath) {
        self.todoList[index.row] = todoItem
        self.tableView.reloadRows(at: [index], with: .automatic)
        self.updateTaskCount()
    }
    
    func changeStatusToDo(isCheck: Bool, todoItem: Todo, index: IndexPath) {
        updateStatusToDoListItem(isCheck: isCheck, todoItem: todoItem, indexPath: index)
    }
    
}
