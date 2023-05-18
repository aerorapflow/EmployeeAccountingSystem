//
//  EmployeeListVC.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 15.03.2023.
//

import UIKit
import CoreData

class EmployeeListVC: UIViewController {
    
    // MARK: - Properties -
    
    private var employeeListVM = EmployeeListVM()
    var fetchedResultsController = CoreDataManager.shared.fetchResultController(entityName: Constants.entity, sortBy: Constants.firstName)
    var isFiltering = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: EmployeeCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search employees..."
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    lazy private var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEmployeeButton))
        return addButton
    }()
    
    // MARK: - Life Cycle VC -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        observerAddingEmployee()
    }
    // MARK: - Setup -
    
    private func setupInterface() {
        fetchedResultsController.delegate = self
        setupConstraints()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = addButton
        title = Constants.tableViewTitle
        definesPresentationContext = true
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func headerTitle(section: Int, fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) -> String? {
        guard let sections = fetchedResultsController.sections else {
            return nil
        }
        let sortedSections = sections.sorted { $0.name < $1.name }
        let departmentName = sortedSections[section].name
        let employeesCount = countEmployeesForDepartment(fetchedResultsController: fetchedResultsController, section: section)
        let employeeWord = (employeesCount == 1) ? "employee" : "employees"
        let title = "\(departmentName): contains \(employeesCount) \(employeeWord)"
        return title
    }
    
    private func countEmployeesForDepartment(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, section: Int) -> Int {
        let employeeCount = fetchedResultsController.sections?[section].numberOfObjects
        return employeeCount ?? 0
    }
    
    private func moveToEmployeeInfo(indexPath: IndexPath) {
        let employee = fetchedResultsController.object(at: indexPath) as! Employee
        let storyboard = UIStoryboard(name: Constants.employeeInfo, bundle: nil)
        guard let employeeInfoVC = storyboard.instantiateViewController(withIdentifier: Constants.employeeInfoVC) as? EmployeeInfoVC else { return }
        employeeInfoVC.employee = employee
        show(employeeInfoVC, sender: nil)
    }
    
    private func observerAddingEmployee() {
        NotificationCenter.default.addObserver(self, selector: #selector(addNewEmployee), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc private func addNewEmployee() {
        tableView.reloadData()
    }
    
    @objc private func addNewEmployeeButton() {
        pushVC(storyboardName: Constants.newEmployee, vcID: Constants.newEmployeeVC)
    }
    
    deinit {
        print("Deinit EmployeeListVC")
        NotificationCenter.default.removeObserver(self)
    }
}

extension EmployeeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        employeeListVM.numberOfSections(fetchedResultsController: fetchedResultsController)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employeeListVM.numbersOfRowInSection(section: section, fetchedResultsController: fetchedResultsController)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier, for: indexPath) as? EmployeeCell,
              let model = fetchedResultsController.sections?[indexPath.section].objects?[indexPath.row] as? Employee else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moveToEmployeeInfo(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: headerView.frame.width - 16, height: headerView.frame.height))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = headerTitle(section: section, fetchedResultsController: fetchedResultsController)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: footerView.frame.width - 16, height: footerView.frame.height))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = employeeListVM.footerTitle(section: section, fetchedResultsController: fetchedResultsController)
        footerView.addSubview(label)
        return footerView
    }
}
