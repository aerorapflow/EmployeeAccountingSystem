//
//  EmployeeInfoVC.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 16.03.2023.
//

import UIKit

class EmployeeInfoVC: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    static let shared = EmployeeInfoVC()
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillingFields()
    }
    
    func fillingFields() {
        guard let employee = employee else { return }
        firstNameTextField.text = employee.firstName
        lastNameTextField.text = employee.lastName
        genderSegmentControl.selectedSegmentIndex = employee.gender == "Male" ? 0 : 1
        salaryTextField.text = String(employee.salary)
        departmentTextField.text = employee.department
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if let birthday = employee.birthdate {
            birthdayTextField.text = dateFormatter.string(from: birthday)
        }
    }
}


