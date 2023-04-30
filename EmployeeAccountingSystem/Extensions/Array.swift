//
//  Array.swift
//  EmployeeAccountingSystem
//
//  Created by DMYTRO on 15.04.2023.
//

import UIKit

extension Array where Element: FloatingPoint {
    func average() -> Element? {
        guard !self.isEmpty else { return nil }
        let total = self.reduce(0, +)
        return total / Element(self.count)
    }
}

