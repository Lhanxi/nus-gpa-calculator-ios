//
//  FinalGPACalculator.swift
//  NUS GPA Calculator
//
//  Created by Leung Han Xi on 15/5/26.
//

import SwiftUI

struct FinalGPACalculatorView: View {
    @StateObject private var viewModel = GPACalculatorViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FocusState private var isInputFocused: Bool
    
    @State private var moduleCode = ""
    @State private var credits = ""
    @State private var selectedGrade: Grade = .aPlus
    @State private var selectedSemester: Semester = .yearOneSemesterOne
    @State private var isExpanded: Set<String> = []
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("NUS GPA Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Text("Final GPA")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(viewModel.formattedGPA)
                    .font(.system(size: 48, weight: .bold))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
            
            HStack(spacing: 12) {
                TextField("Module code", text: $moduleCode)
                    .textInputAutocapitalization(.characters)
                    .focused($isInputFocused)
                    .disableAutocorrection(true)
                
                TextField("Credits", text: $credits)
                    .keyboardType(.numberPad)
                    .focused($isInputFocused)
                    .disableAutocorrection(true)
                
                Picker("Grade", selection: $selectedGrade) {
                    ForEach(Grade.allCases) { grade in
                        Text(grade.rawValue)
                            .tag(grade)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Semester", selection: $selectedSemester) {
                    ForEach(Semester.allCases) { semester in
                        Text(semester.rawValue)
                            .tag(semester)
                    }
                }
                .pickerStyle(.menu)
            }
            Button("Add Module") {
                addModule()
            }
            
            List{
                ForEach(viewModel.modules.groupedBySemester) { group in
                    Section (
                        isExpanded: expansionBinding(for: group),
                        content: {
                            ForEach(group.modules) { module in
                                HStack {
                                    Text(module.moduleCode)
                                    Text("\(module.credits) MCs")
                                    Spacer()
                                    Text(module.grade.rawValue)
                                    Text(module.semester.rawValue)
                                    
                                    Button {
                                        viewModel.deleteModule(module)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        },
                        header: {
                            Text(group.title)
                        }
                    )
                }
            }
            .listStyle(.sidebar)
            Spacer()
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                isInputFocused = false
            }
        )
        .onAppear {
            viewModel.loadModules()
        }
        .padding()
    }
    
    private func addModule() {
        guard let creditValue = Int(credits) else {
            return
        }
        
        viewModel.addModule(moduleCode: moduleCode, credits: creditValue, grade: selectedGrade, semester: selectedSemester, context: viewContext)
        
        moduleCode = ""
        credits = ""
        selectedGrade = .aPlus
        selectedSemester = .yearOneSemesterOne
        
        isInputFocused = false
    }
    
    private func expansionBinding(for group: SemesterModuleGroup) -> Binding<Bool> {
        Binding<Bool> (
            get: {
                return isExpanded.contains(group.title)
            },
            set: { isExpanding in
                if isExpanding {
                    isExpanded.insert(group.title)
                } else {
                    isExpanded.remove(group.title)
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        FinalGPACalculatorView()
    }
}
