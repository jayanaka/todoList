//
//  ToDoListTVC.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit
import SimpleCheckbox

protocol ToDoItemDelegate {
    func changeStatusToDo(isCheck: Bool, todoItem: Todo, index: IndexPath)
    func addToDoItemToList(todoItem: Todo)
    func updateToDoItemInList(todoItem: Todo, index: IndexPath)
}

class ToDoListTVC: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    
    var delegate: ToDoItemDelegate?
    var todoItem: Todo?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        checkBox.borderStyle = .square
        checkBox.checkedBorderColor = UIColor.init(hexString: Common.themeColor)
        checkBox.checkmarkColor = UIColor.init(hexString: Common.themeColor)
        checkBox.borderCornerRadius = 5.0
        checkBox.checkmarkSize = 0.6
        checkBox.uncheckedBorderColor = .gray
        checkBox.checkmarkStyle = .tick
        
        checkBox.addTarget(self, action: #selector(checkBoxValueChanged(sender:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // target action checkBox
    @objc func checkBoxValueChanged(sender: Checkbox) {
        self.delegate?.changeStatusToDo(isCheck: sender.isChecked, todoItem: todoItem!, index: index!)
    }

}
