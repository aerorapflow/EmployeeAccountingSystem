//
//  Employee+CoreDataProperties.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 07.03.2023.
//
//

import Foundation
import CoreData

extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var salary: Double
    @NSManaged public var department: String?
    @NSManaged public var gender: String
    @NSManaged public var birthdate: Date?
}

extension Employee : Identifiable {

}
