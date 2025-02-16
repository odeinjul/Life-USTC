//
//  SettingsView.swift
//  Life@USTC (iOS)
//
//  Created by TiankaiMa on 2022/12/17.
//

import SwiftUI

struct SettingsView: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLinkAddon("Feed Source Settings", destination: FeedSettingView())
                    NavigationLinkAddon("CAS Settings", destination: CASLoginView.newPage)
#if DEBUG
                    NavigationLinkAddon("Change User Type", destination: UserTypeView())
#endif
                    NavigationLinkAddon("Exam Settings", destination: ExamSettingView())
//                    NavigationLinkAddon("Health Check", destination: HealthCheckPage())
#if os(iOS)
                    NavigationLinkAddon("Notification Settings", destination: NotificationSettingView())
#endif
                }

                Section {
                    NavigationLinkAddon("About Life@USTC", destination: AboutLifeAtUSTCView())
                    NavigationLinkAddon("Legal Info", destination: LegalInfoView())
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
//            .searchable(text: $searchText, placement: .toolbar)
        }
    }
}
