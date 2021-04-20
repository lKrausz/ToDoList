//
//  TableViewCell.swift
//  todolist
//
//  Created by Виктория Козырева on 17.03.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    var todoItemLabel = UILabel.init()
    var complite: Bool = false
    
    func config(todoItem: ToDoItemModel) {
        contentView.addSubview(todoItemLabel)
        setupConstraints()
        todoItemLabel.text = todoItem.title
        complite = todoItem.isCompletion
        layoutIfNeeded()
    }
    
    func setupConstraints() {
        todoItemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: todoItemLabel, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: todoItemLabel, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: todoItemLabel, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: todoItemLabel, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
        
    }
    
    func changeComplitionState(isComplite: Bool) {
        self.complite = isComplite
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if complite == true {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
    }
    
    override var reuseIdentifier: String? {
        return "TableViewCell"
    }
    
}

