//
//  SettingsView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @State private var isLockEnabled = false
    @State private var isExporting = false
    @State private var exportError: String?
    
    private var authService: AuthenticationService {
        AuthenticationService.shared
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Privacy section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appText)
                        
                        Text("All data is stored locally on your device. Nothing is shared. No analytics. No remote logging.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.appSecondary)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color(hex: "2C2C2E"))
                }
                
                // Features
                Section {
                    Toggle("Face ID / Passcode Lock", isOn: Binding(
                        get: { isLockEnabled },
                        set: { newValue in
                            isLockEnabled = newValue
                            authService.isLockEnabled = newValue
                        }
                    ))
                    .onAppear {
                        isLockEnabled = authService.isLockEnabled
                    }
                    .listRowBackground(Color(hex: "2C2C2E"))
                    
                    Button(action: {
                        exportEntries()
                    }) {
                        HStack {
                            Text("Export entries")
                                .foregroundColor(.appText)
                            Spacer()
                            if isExporting {
                                ProgressView()
                                    .tint(.appText)
                            } else {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.appSecondary)
                            }
                        }
                    }
                    .disabled(isExporting)
                    .listRowBackground(Color(hex: "2C2C2E"))
                    
                    NavigationLink(destination: ReflectionView()) {
                        HStack {
                            Text("Reflection")
                                .foregroundColor(.appText)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.appSecondary)
                                .font(.system(size: 12))
                        }
                    }
                    .listRowBackground(Color(hex: "2C2C2E"))
                } header: {
                    Text("Features")
                }
                
                // About section
                Section {
                    NavigationLink(destination: SupportResourcesView()) {
                        Text("Support Resources")
                            .foregroundColor(.appText)
                    }
                    .listRowBackground(Color(hex: "2C2C2E"))
                } header: {
                    Text("About")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Export", isPresented: Binding(
                get: { exportError != nil },
                set: { if !$0 { exportError = nil } }
            )) {
                Button("OK") {
                    exportError = nil
                }
            } message: {
                if let error = exportError {
                    Text(error)
                }
            }
        }
    }
    
    private func exportEntries() {
        guard !entries.isEmpty else {
            exportError = "No entries to export"
            return
        }
        
        isExporting = true
        exportError = nil
        
        // Get the root view controller to present share sheet
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                ExportService.shared.shareEntries(self.entries, in: rootViewController)
            }
            self.isExporting = false
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Entry.self, inMemory: true)
}
