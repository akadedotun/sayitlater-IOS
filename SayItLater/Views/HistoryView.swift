//
//  HistoryView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEntry: Entry?
    
    var body: some View {
        NavigationStack {
            if entries.isEmpty {
                VStack(spacing: 20) {
                    Text("No entries yet")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.appSecondary)
                    Text("Your saved entries will appear here")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.appSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackground)
                .navigationTitle("History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            } else {
                List {
                    ForEach(entries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            EntryCard(entry: entry)
                        }
                        .listRowBackground(Color(hex: "2C2C2E"))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.appBackground)
                .navigationTitle("History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct EntryCard: View {
    let entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // First line preview
            Text(entry.text.components(separatedBy: .newlines).first ?? entry.text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.appText)
                .lineLimit(2)
            
            HStack {
                // Date
                Text(entry.date, style: .date)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appSecondary)
                
                Spacer()
                
                // Feeling result
                Text(entry.feeling.displayName.capitalized)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Entry.self, inMemory: true)
}
