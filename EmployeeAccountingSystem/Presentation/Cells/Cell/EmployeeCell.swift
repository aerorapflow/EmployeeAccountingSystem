//
//  EmployeeCell.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 21.03.2023.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    static let identifier = "EmployeeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: Employee) {
        firstNameLabel.text = model.firstName
        lastNameLabel.text = model.lastName
    }
}
