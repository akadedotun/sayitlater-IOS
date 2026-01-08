//
//  ExportService.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import SwiftUI

class ExportService {
    static let shared = ExportService()
    
    private init() {}
    
    func exportEntries(_ entries: [Entry]) -> URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        var exportText = "Say It Later - Exported Entries\n"
        exportText += "Exported on: \(dateFormatter.string(from: Date()))\n"
        exportText += "Total entries: \(entries.count)\n\n"
        exportText += String(repeating: "=", count: 50) + "\n\n"
        
        for (index, entry) in entries.enumerated() {
            exportText += "Entry \(index + 1)\n"
            exportText += "Date: \(dateFormatter.string(from: entry.date))\n"
            exportText += "Feeling: \(entry.feeling.displayName.capitalized)\n"
            exportText += String(repeating: "-", count: 30) + "\n"
            exportText += entry.text
            exportText += "\n\n"
            exportText += String(repeating: "=", count: 50) + "\n\n"
        }
        
        // Create temporary file
        let fileName = "SayItLater_Export_\(Date().timeIntervalSince1970).txt"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try exportText.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL
        } catch {
            print("Failed to export entries: \(error)")
            return nil
        }
    }
    
    func shareEntries(_ entries: [Entry], in viewController: UIViewController) {
        guard let url = exportEntries(entries) else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true)
    }
}
