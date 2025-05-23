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
    @ObservedObject var moodManager = MoodManager.shared

    let whatsNewURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/releases")!
    let rateAppURL = URL(string: "https://apps.apple.com/app/com.jcube.mymoodz")!
    let privacyPolicyURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/PRIVACY_POLICY.md")!
    let openSourceURL = URL(string: "https://github.com/NaagAlgates/MyMoodz")!
    let licensesURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/LICENSE.md")!
    let onBoardingURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/ONBOARDING.md")!
    let appFeaturesURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/blob/docs/docs/FEATURES.md")!
    let developerURL = URL(string: "https://nagaraj.com.au")!
    let issueURL = URL(string: "https://github.com/NaagAlgates/MyMoodz/issues")!

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                content
            } else {
                NavigationView {
                    content
                }
            }
        }
    }

    var content: some View {
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
                    MailView(recipientEmail: "me@nagaraj.com.au")
                }
                .alert(isPresented: $showMailErrorAlert) {
                    Alert(
                        title: Text("Mail Not Supported"),
                        message: Text("Please configure a mail account on your device to send feedback. Or send an email to me@nagaraj.com.au"),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Text("This app is developed by one person and with the help of generative AI. I appreciate your feedback and it will try to improve the quality of the app")
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

                Link(destination: issueURL) {
                    Label("Report Issues", systemImage: "ladybug")
                }
            }

            Section(header: Text("General")) {
                Link(destination: appFeaturesURL) {
                    Label("App Features", systemImage: "sparkle")
                }
                Link(destination: onBoardingURL) {
                    Label("Onboarding", systemImage: "book")
                }
                Link(destination: licensesURL) {
                    Label("Licenses", systemImage: "doc.plaintext")
                }
            }

            Section(header: Text("About")) {
                Link(destination: developerURL) {
                    Label("Developer", systemImage: "person.circle")
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
        .tint(moodManager.selectedColor)
    }

    func getAppVersionString() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        #if DEBUG
        let schema = "Development"
        #elseif PROD
        let schema = "Production"
        #else
        let schema = "[UNKNOWN]"
        #endif

        return "v\(version) (\(buildVersion))\n\(schema)"
    }
}
