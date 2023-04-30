//
//  Employee+CoreDataClass.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 07.03.2023.
//
//

import Foundation
import CoreData

class Employee: NSManagedObject {
    
    convenience init() {
        let context = CoreDataManager.shared.context
        guard let entityDescription = CoreDataManager.shared.entityDescription(entityName: Constants.employeeClassName) else {
            fatalError("Entity '\(Constants.employeeClassName)' does not exist")
        }
        self.init(entity: entityDescription, insertInto: context)
    }
}
