//
//  Module.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import Foundation

struct Module: Identifiable {
    let id: UUID
    var moduleCode: String
    var credits: Int
    var grade: Grade
    var semester: Semester
    
    init(id: UUID = UUID(), moduleCode: String, credits: Int, grade: Grade, semester: Semester) {
        self.id = id
        self.moduleCode = moduleCode
        self.credits = credits
        self.grade = grade
        self.semester = semester
    }
}

struct SemesterModuleGroup: Identifiable {
    let semester: Semester
    let modules: [Module]
    
    var id: String {
        semester.rawValue
    }
    
    var title: String {
        semester.rawValue
    }
}

extension Array where Element == Module {
    var groupedBySemester: [SemesterModuleGroup] {
        Semester.allCases.compactMap { semester in
            let modulesInSemester = self.filter { module in
                module.semester == semester
            }
            guard !modulesInSemester.isEmpty else { return nil }
            return SemesterModuleGroup(semester: semester, modules: modulesInSemester)
        }
    }
}
