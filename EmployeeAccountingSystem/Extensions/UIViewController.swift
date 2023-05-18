//
//  Extensions.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 16.03.2023.
//

import Foundation
import UIKit


extension UIViewController {
    // MARK: - Pushing ViewController - 
    func pushVC(storyboardName name: String, vcID: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: vcID)
        navigationController?.pushViewController(vc, animated: true)
    }
}


