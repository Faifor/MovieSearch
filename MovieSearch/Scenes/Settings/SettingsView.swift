//
//  SettingsView.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 16.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModa") private var isDarkModa = false
    @AppStorage("varnotifications") private var varnotifications = true
        
    var body: some View {
        Form {
            Section(header: Text("Общие")) {
                Toggle("Тёмная тема", isOn: $isDarkModa)
                Toggle("Уведомления", isOn: $varnotifications)
            }
        }
        .navigationTitle("Настройки")
    }
}
