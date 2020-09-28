//
//  ToDoTableViewController.swift
//  ToDoListApp
//
//  Created by James Monahan on 9/27/20.
//  Copyright © 2020 James Monahan. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("📅 I JUST CREATED A DATE FORMATTER!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ToDoTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var nameField: UITextField!
    var toDoItem: ToDoItem!
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notePickerIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    override func viewDidLoad() {
        super.viewDidLoad()
        if toDoItem == nil{
           
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSwitch: false)
        }
        updateUserInterface()
    }
    
    func updateUserInterface(){
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSwitch
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSwitch: reminderSwitch.isOn)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
}
extension ToDoTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notePickerIndexPath :
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}
