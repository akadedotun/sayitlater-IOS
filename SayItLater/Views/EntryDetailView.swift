//
//  EntryDetailView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    let entry: Entry
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showSupportResources = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Full text
                Text(entry.text)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.appText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .background(Color.appSecondary.opacity(0.3))
                
                // Date
                HStack {
                    Text("Date")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appSecondary)
                    Spacer()
                    Text(entry.date, style: .date)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.appSecondary)
                }
                
                // Feeling result
                HStack {
                    Text("Feeling")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appSecondary)
                    Spacer()
                    Text(entry.feeling.displayName.capitalized)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.appSecondary)
                }
                
                // Safety support action (if safety flag is set)
                if entry.safetyFlag {
                    Divider()
                        .background(Color.appSecondary.opacity(0.3))
                    Button(action: {
                        showSupportResources = true
                    }) {
                        HStack {
                            Text("Get support")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.appAccent)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.appAccent)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Delete entry?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(entry)
                dismiss()
            }
        } message: {
            Text("This cannot be undone.")
        }
        .sheet(isPresented: $showSupportResources) {
            NavigationStack {
                SupportResourcesView()
                    .navigationTitle("Support")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showSupportResources = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(entry: Entry(text: "Sample entry text", date: Date(), feeling: .lighter, safetyFlag: false))
    }
    .modelContainer(for: Entry.self, inMemory: true)
}
