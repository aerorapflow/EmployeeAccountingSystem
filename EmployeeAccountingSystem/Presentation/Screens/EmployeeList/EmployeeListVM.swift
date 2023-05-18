////
////  EmployeeListVM.swift
////  EmployeeAccountingSystem
////
////  Created by DMYTRO on 28.04.2023.
////
//
import Foundation
import CoreData

class EmployeeListVM {
    
    // MARK: - Number of sections -
    func numberOfSections(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) -> Int {
        fetchedResultsController.sections?.count ?? .zero
    }
    // MARK: - Numbers of rows in section-
    func numbersOfRowInSection(section: Int, fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? .zero
    }
    
    // MARK: - Title for header -
    func headerTitle(section: Int, fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>) -> String? {
        guard let sections = fetchedResultController.sections else {
            return nil
        }
        let sortedSections = sections.sorted { $0.name < $1.name }
        let departmentName = sortedSections[section].name
        let employeesCount = countEmployeesForDepartment(fetchedResultsController: fetchedResultController, section: section)
        let employeeWord = (employeesCount == 1) ? "employee" : "employees"
        let title = "\(departmentName): contains \(employeesCount) \(employeeWord)"
        return title
    }
    
    // MARK: - Employees counting -
    func countEmployeesForDepartment(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, section: Int) -> Int {
        let employeeCount = fetchedResultsController.sections?[section].numberOfObjects
        return employeeCount ?? 0
    }
    
    
    // MARK: - Title for footer -
    func footerTitle(section: Int, fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) -> String {
        let unknownDepartment = "Unknown department"
        
        guard let sections = fetchedResultsController.sections else {
            return unknownDepartment
        }
        
        let currentSection = sections[section] as NSFetchedResultsSectionInfo
        
        guard let employees = currentSection.objects as? [Employee] else {
            return unknownDepartment
        }
        
        let totalSalary = employees.reduce(0, { $0 + Double($1.salary) })
        let averageSalary = totalSalary / max(1.0, Double(employees.count))
        return "Average salary - \(averageSalary) dollars."
    }
}
