//
//  ContentView.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack {
            HomeView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

#Preview {
    ContentView()
}
