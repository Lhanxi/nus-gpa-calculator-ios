//
//  Persistence.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NUS_GPA_Calculator")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    func saveModule(moduleCode: String, credits: Int, grade: Grade, semester: Semester) async throws -> Module {
            let context = container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            return try await context.perform {
                let entity = ModuleEntity(context: context)
                entity.id = UUID()
                entity.moduleCode = moduleCode
                entity.credits = Int16(credits)
                entity.grade = grade.rawValue
                entity.semester = semester.rawValue
                
                try context.save()
                
                return Module(id: entity.id!, moduleCode: moduleCode, credits: credits, grade: grade, semester: semester)
            }
        }
    
    func deleteModule(moduleID: UUID) async throws {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        try await context.perform {
            let request: NSFetchRequest<ModuleEntity> = ModuleEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", moduleID as CVarArg)
            request.fetchLimit = 1
            
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
            } else {
                throw NSError(domain: "GPACalculator", code: 404, userInfo: [NSLocalizedDescriptionKey: "Module not found"])
            }
        }
    }
}
