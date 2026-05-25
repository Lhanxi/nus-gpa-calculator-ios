//
//  GPACalculatorViewModel.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import Foundation
import CoreData

class GPACalculatorViewModel: ObservableObject {
    @Published var modules: [Module] = []
    private let persistenceController = PersistenceController.shared
    
    func addModule(moduleCode: String, credits: Int, grade: Grade, semester: Semester, context: NSManagedObjectContext) {
        Task {
            do {
                let module = try await persistenceController.saveModule(
                    moduleCode: moduleCode,
                    credits: credits,
                    grade: grade,
                    semester: semester)
                
                await MainActor.run {
                    modules.append(module)
                }
            } catch {
                print("Failed to save module in background: \(error)")
            }
        }
    }
    
    func loadModules() {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<ModuleEntity> = ModuleEntity.fetchRequest()
        
        do {
            let savedModules = try context.fetch(request)
            self.modules = savedModules.map { moduleEntity in
                Module(
                    moduleCode: moduleEntity.moduleCode ?? "",
                    credits: Int(moduleEntity.credits),
                    grade: Grade(rawValue: moduleEntity.grade ?? "") ?? .aPlus,
                    semester: Semester(rawValue: moduleEntity.semester ?? "") ?? .yearOneSemesterOne
                )
            }
        } catch {
            print("Failed to load modules from Core Data:", error)
        }
    }
    
    func deleteModule(_ module: Module) {
//        modules.removeAll { currentModule in
//            currentModule.id == module.id
//        }
        Task {
            do {
                try await persistenceController.deleteModule(moduleID: module.id)
                // Only remove from UI after successful deletion
                await MainActor.run {
                    if let index = modules.firstIndex(where: { $0.id == module.id }) {
                        modules.remove(at: index)
                    }
                }
            } catch {
                print("Failed to delete module: \(error)")
            }
        }
    }
    
    var totalGradePoints: Double {
        modules.reduce(0.00) { total, module in
            guard let gradePoint = module.grade.gradePoint else {
                return total
            }
            return total + Double(module.credits) * gradePoint
        }
    }
    
    var totalGradeCredits: Int {
        modules
//            .filter{ module in
//                module.grade.contributesToGPA }
            .filter {
                $0.grade.contributesToGPA
            }
            .reduce(0) { total, module in
                total + module.credits
            }
    }
    
    var gpa: Double {
        guard totalGradeCredits > 0 else {
            return 0.00
        }
        return totalGradePoints / Double(totalGradeCredits)
    }
    
    var formattedGPA: String {
        String(format: "%.2f", gpa)
    }
}
