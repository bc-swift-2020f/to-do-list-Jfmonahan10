//
//  ListTableViewCell.swift
//  ToDoListApp
//
//  Created by James Monahan on 10/4/20.
//  Copyright © 2020 James Monahan. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
    
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    weak var delegate: ListTableViewCellDelegate?
     
    var toDoItem: ToDoItem! {
        didSet {
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    @IBAction func checkBoxToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
