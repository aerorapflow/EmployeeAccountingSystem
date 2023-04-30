//
//  NewEmployeeVC.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 07.03.2023.
//

import UIKit
import CoreData


final class NewEmployeeVC: UIViewController, UITextFieldDelegate {
    
    private let dataBase = CoreDataManager.shared
    let datePicker = UIDatePicker()
    let employeeListVC = EmployeeListVC()
    var didSaveNewEmployee: (() -> Void)?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        salaryTextField.delegate = self
        salaryTextField.keyboardType = .decimalPad
        addKeyboardObservers()
        createDatePicker()
        tapGesture()
    }
    
    func clearTheFields() {
        firstNameTextField.text = .empty
        lastNameTextField.text = .empty
        genderSegmentedControl.selectedSegmentIndex = 0
        salaryTextField.text = .empty
        departmentTextField.text = .empty
    }
    
    func saveAlert() {
        let saveAlert = UIAlertController(title: "Saving", message: "Save successfully", preferredStyle: .alert)
        saveAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(saveAlert, animated: true)
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn], animated: true)
        return toolbar
    }
    
    @objc func doneBtnPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let minDate = dateFormatter.date(from: "01/01/1960")
        datePicker.minimumDate = minDate
        let maxDate = dateFormatter.date(from: "31/12/2004")
        datePicker.maximumDate = maxDate
        birthdayTextField.inputView = datePicker
        birthdayTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = 205 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let salary = salaryTextField.text,
              let department = departmentTextField.text,
              let birthday = birthdayTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !salary.isEmpty,
              !department.isEmpty,
              !birthday.isEmpty
        else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        if let entityDescription = dataBase.entityDescription(entityName: "Employee") {
            let managedObject = Employee(entity: entityDescription, insertInto: dataBase.context)
            managedObject.firstName = firstName
            managedObject.lastName = lastName
            managedObject.department = department
            let selectedGenderIndex = genderSegmentedControl.selectedSegmentIndex
            managedObject.gender = selectedGenderIndex == 0 ? "Male" : "Female"
            let birthday = datePicker.date
            managedObject.birthdate = birthday
            if let salaryValue = Double(salary) {
                managedObject.salary = salaryValue
            } else {
                managedObject.salary = 0.0
            }
            dataBase.saveContext()
            saveAlert()
            didSaveNewEmployee?()
            clearTheFields()
        } else {
            return
        }
    }
    
}




