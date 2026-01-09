//
//  ContentView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Initialize AppState immediately but keep it lightweight
    @State private var appState = AppState()
    @Environment(\.modelContext) private var modelContext
    @State private var showHistory = false
    @State private var showSupportResources = false
    @State private var showSettings = false
    @State private var isLocked = false
    @State private var lockEnabled = false
    @State private var safetyDetection: SafetyDetectionService?
    
    var body: some View {
        // Show splash immediately - it's the first thing users should see
        Group {
            if appState.showSplash {
                SplashView(showSplash: $appState.showSplash)
            } else if isLocked {
                LockView(onUnlock: {
                    isLocked = false
                })
            } else if !appState.hasSeenWelcome {
                WelcomeView(hasSeenWelcome: $appState.hasSeenWelcome)
            } else if appState.showSafetySupport {
                SafetySupportView(
                    onGetSupport: {
                        showSupportResources = true
                    },
                    onNotRightNow: {
                        appState.showSafetySupport = false
                        appState.showPostWritingActions = true
                    }
                )
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
            } else {
                // Main writing screen
                NavigationStack {
                    WritingView(draft: $appState.currentDraft) {
                        // Done button tapped
                        appState.showFeelingSelection = true
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showHistory = true
                            }) {
                                Image(systemName: "clock")
                            }
                        }
                    }
                    .sheet(isPresented: $appState.showFeelingSelection) {
                            FeelingSelectionView(selectedFeeling: $appState.selectedFeeling) { feeling in
                                appState.selectedFeeling = feeling
                                
                                // Check for safety issues (lazy init)
                                if safetyDetection == nil {
                                    safetyDetection = SafetyDetectionService()
                                }
                                let hasSafetyIssue = safetyDetection?.detectSafetyIssues(in: appState.currentDraft) ?? false
                                appState.detectedSafetyIssue = hasSafetyIssue
                            
                            // Dismiss feeling selection and show next screen
                            appState.showFeelingSelection = false
                            
                            // Small delay to allow smooth transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if hasSafetyIssue {
                                    appState.showSafetySupport = true
                                } else {
                                    appState.showPostWritingActions = true
                                }
                            }
                        }
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled(false)
                    }
                    .sheet(isPresented: $appState.showPostWritingActions, onDismiss: {
                        // Ensure draft is cleared when PostWritingActions is dismissed
                        if appState.currentDraft.isEmpty == false {
                            appState.currentDraft = ""
                        }
                    }) {
                        PostWritingActionsView(
                            onKeepForLater: {
                                saveEntry()
                                // Clear draft first, before resetting
                                appState.currentDraft = ""
                                appState.resetWritingFlow()
                                // Dismiss the sheet first, then show history
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    showHistory = true
                                }
                            },
                            onLetGo: {
                                // Delete permanently - just reset and clear
                                appState.currentDraft = ""
                                appState.resetWritingFlow()
                            },
                            onClose: {
                                // Just reset, keep draft (user might want to continue)
                                appState.resetWritingFlow()
                            }
                        )
                        .presentationDetents([.height(320)])
                        .interactiveDismissDisabled(false)
                    }
                    .sheet(isPresented: $showHistory, onDismiss: {
                        // Ensure draft is cleared when history is dismissed
                        appState.currentDraft = ""
                    }) {
                        HistoryView()
                            .onAppear {
                                // Ensure draft is cleared when history appears
                                appState.currentDraft = ""
                            }
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                }
            }
        }
        .onChange(of: appState.showSplash) { _, newValue in
            // Initialize when splash is dismissed
            if !newValue {
                // Check lock status after splash
                lockEnabled = AuthenticationService.shared.isLockEnabled
                if lockEnabled {
                    checkLockStatus()
                }
            }
        }
        .onChange(of: lockEnabled) { _, newValue in
            if newValue {
                checkLockStatus()
            } else {
                isLocked = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            lockEnabled = AuthenticationService.shared.isLockEnabled
            if lockEnabled {
                checkLockStatus()
            }
        }
    }
    
    private func checkLockStatus() {
        let authService = AuthenticationService.shared
        if authService.isLockEnabled {
            isLocked = true
            authService.authenticate { success, _ in
                if success {
                    isLocked = false
                }
            }
        }
    }
    
    private func saveEntry() {
        guard let feeling = appState.selectedFeeling else { return }
        
        let entry = Entry(
            text: appState.currentDraft,
            date: Date(),
            feeling: feeling,
            safetyFlag: appState.detectedSafetyIssue
        )
        
        modelContext.insert(entry)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save entry: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}
