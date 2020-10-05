//
//  ToDoTableViewController.swift
//  ToDoListApp
//
//  Created by James Monahan on 9/27/20.
//  Copyright © 2020 James Monahan. All rights reserved.
//

import UIKit
import UserNotifications

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
        let notifcationCenter = NotificationCenter.default
        notifcationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        nameField.delegate = self
        if toDoItem == nil{
           
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSwitch: false, completed:false )
            nameField.becomeFirstResponder()
        }
        updateUserInterface()
    }
    
    @objc func appActiveNotification(){
        print("zThe app just came to the foreground - cool")
        updateReminderSwitch()
    }
    
    func updateUserInterface(){
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSwitch
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        enableDisableSaveButton(text: nameField.text!)
        updateReminderSwitch()
    }
    
    func updateReminderSwitch(){
        LocalNotificationManager.isAuthorized{(authorized) in
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn {
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To Receive alerts for reminders, open the settings app, select To Do List > Notifcations > Allow Notifications ")
                    self.reminderSwitch.isOn = false
                }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSwitch: reminderSwitch.isOn, completed: toDoItem.completed)
    }
    
    func enableDisableSaveButton(text: String){
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
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
        updateReminderSwitch()
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
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

extension ToDoTableViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}
