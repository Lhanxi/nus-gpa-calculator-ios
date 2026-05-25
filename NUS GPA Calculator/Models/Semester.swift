//
//  Semester.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import Foundation

enum Semester: String, CaseIterable, Identifiable {
    case yearOneSemesterOne = "Y1S1"
    case yearOneSemesterTwo = "Y1S2"
    case yearTwoSemesterOne = "Y2S1"
    case yearTwoSemesterTwo = "Y2S2"
    case yearThreeSemesterOne = "Y3S1"
    case yearThreeSemesterTwo = "Y3S2"
    case yearFourSemesterOne = "Y4S1"
    case yearFourSemesterTwo = "Y4S2"
    case yearFiveSemesterOne = "Y5S1"
    case yearFiveSemesterTwo = "Y5S2"
    
    var id: String {
        self.rawValue
    }
}
