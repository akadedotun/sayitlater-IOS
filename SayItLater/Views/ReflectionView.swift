//
//  ReflectionView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import SwiftData

struct ReflectionView: View {
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    
    private var feelingCounts: [FeelingResult: Int] {
        Dictionary(grouping: entries, by: { $0.feeling })
            .mapValues { $0.count }
    }
    
    private var mostCommonFeeling: FeelingResult? {
        feelingCounts.max(by: { $0.value < $1.value })?.key
    }
    
    private var totalEntries: Int {
        entries.count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Reflection")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(.appText)
                    .padding(.top, 40)
                
                if totalEntries == 0 {
                    VStack(spacing: 16) {
                        Text("No entries yet")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.appSecondary)
                        Text("Write a few entries to see insights")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.appSecondary)
                    }
                    .padding(.top, 60)
                } else {
                    VStack(spacing: 24) {
                        // Total entries
                        InsightCard(
                            title: "Total entries",
                            value: "\(totalEntries)",
                            subtitle: totalEntries == 1 ? "entry" : "entries"
                        )
                        
                        // Most common feeling
                        if let mostCommon = mostCommonFeeling {
                            InsightCard(
                                title: "Most entries felt",
                                value: mostCommon.displayName.capitalized,
                                subtitle: "\(feelingCounts[mostCommon] ?? 0) \(feelingCounts[mostCommon] == 1 ? "entry" : "entries")"
                            )
                        }
                        
                        // Feeling breakdown
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Feeling breakdown")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appText)
                            
                            ForEach(FeelingResult.allCases, id: \.self) { feeling in
                                let count = feelingCounts[feeling] ?? 0
                                let percentage = totalEntries > 0 ? Double(count) / Double(totalEntries) * 100 : 0
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(feeling.displayName.capitalized)
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.appText)
                                        Spacer()
                                        Text("\(count)")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.appText)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color(hex: "3A3A3C"))
                                                .frame(height: 8)
                                                .cornerRadius(4)
                                            
                                            Rectangle()
                                                .fill(Color.appAccent)
                                                .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color(hex: "2C2C2E"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground)
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.appSecondary)
            
            Text(value)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.appText)
            
            Text(subtitle)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.appSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(12)
    }
}

#Preview {
    ReflectionView()
        .modelContainer(for: Entry.self, inMemory: true)
}
