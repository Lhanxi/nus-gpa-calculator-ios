//
//  HomeView.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        VStack(spacing: 20) {
            Text("NUS GPA Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Calculate your final GPA and track modules by semester")
                .multilineTextAlignment(.center)
                .font(.subheadline)
        }
        NavigationLink {
            FinalGPACalculatorView()
                .environment(\.managedObjectContext, viewContext)
        } label : {
            Text("Calculate Final GPA")
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

