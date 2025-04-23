//
//  SettingsScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/4/2025.
//

import SwiftUI
import MessageUI

struct SettingsScreen: View {
    @State private var isShowingMailView = false
    @State private var showMailErrorAlert = false
    
    let whatsNewURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/releases")!
    let rateAppURL = URL(string: "https://www.nagaraj.com.au")!
    let privacyPolicyURL = URL(string: "https://www.nagaraj.com.au")!
    let openSourceURL = URL(string: "https://github.com/NaagAlgates/MyMoodz")!
    let licensesURL = URL(string: "https://www.nagaraj.com.au")!


    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feedback")) {
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            isShowingMailView = true
                        } else {
                            showMailErrorAlert = true
                        }
                    }) {
                        Label("Give Feedback", systemImage: "flag")
                    }
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(recipientEmail: "xxx@g.com")
                    }
                    .alert(isPresented: $showMailErrorAlert) {
                        Alert(
                            title: Text("Mail Not Supported"),
                            message: Text("Please configure a mail account on your device to send feedback."),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    Text("This app is developed by one person and with the help of generative AI. I appreciate your feedback and will try to improve the features and code")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }


                Section(header: Text("App Details")) {
                    Link(destination: whatsNewURL) {
                        Label("What's new", systemImage: "sparkles")
                    }

                    Link(destination: rateAppURL) {
                        Label("Rate this app", systemImage: "star")
                    }

                    Link(destination: privacyPolicyURL) {
                        Label("Privacy", systemImage: "lock")
                    }

                    Link(destination: openSourceURL) {
                        Label("MyMoodz is open source", systemImage: "curlybraces")
                    }
                }


                Section(header: Text("General")) {
                    NavigationLink(destination: Text("Onboarding")) {
                        Label("Onboarding", systemImage: "book")
                    }
                    NavigationLink(destination: Text("Statistics")) {
                        Label("Statistics for Nerds", systemImage: "chart.pie")
                    }
                    Link(destination: licensesURL) {
                        Label("Licenses", systemImage: "doc.plaintext")
                    }
                }

                Text(getAppVersionString())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                
            }
            
            .navigationTitle("Settings")
            Spacer()
        }
    }
    
    func getAppVersionString() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        #if DEBUG
        let schema = "Development"
        #elseif PROD
        let schema = "Production"
        #else
        let schema = "[UNKNOWN]"
        #endif

        return "v\(version) \n\(schema)"
    }
}
