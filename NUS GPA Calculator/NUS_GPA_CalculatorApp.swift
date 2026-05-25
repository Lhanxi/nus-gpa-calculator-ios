//
//  NUS_GPA_CalculatorApp.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import SwiftUI

@main
struct NUS_GPA_CalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
