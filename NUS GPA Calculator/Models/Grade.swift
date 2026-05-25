//
//  Grade.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import Foundation

enum Grade: String, CaseIterable, Identifiable {
    case aPlus = "A+"
    case a = "A"
    case aMinus = "A-"
    case bPlus = "B+"
    case b = "B"
    case bMinus = "B-"
    case cPlus = "C+"
    case c = "C"
    case dPlus = "D+"
    case d = "D"
    case f = "F"
    
    case satisfactory = "S"
    case unsatisfactory = "U"
    case completedSatisfactory = "CS"
    case completedUnsatisfactory = "CU"
    case incomplete = "IC"
    case inProgress = "IP"
    case withdrawn = "W"
    case audit = "AUD"
    case exempted = "EXE"
    case withdrawalUniversity = "WU"
    
    var id: String {
        self.rawValue
    }
    
    var gradePoint: Double? {
        switch self {
        case .aPlus, .a:
            return 5.00
        case .aMinus:
            return 4.50
        case .bPlus:
            return 4.00
        case .b:
            return 3.50
        case .bMinus:
            return 3.00
        case .cPlus:
            return 2.50
        case .c:
            return 2.00
        case .dPlus:
            return 1.50
        case .d:
            return 1.00
        case .f:
            return 0.00
        case .satisfactory,
                .unsatisfactory,
                .completedSatisfactory,
                .completedUnsatisfactory,
                .incomplete,
                .inProgress,
                .withdrawn,
                .audit,
                .exempted,
                .withdrawalUniversity:
            return nil
        }
    }
    var contributesToGPA: Bool {
            gradePoint != nil
    }
}
