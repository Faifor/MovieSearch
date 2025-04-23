//
//  SearchBar.swift
//  MovieSearch
//
//  Created by Данила Спиридонов on 01.04.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    var onClear: () -> Void

    var body: some View {
        HStack {
            TextField("Поиск", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit {
                    hideKeyboard()
                    onSearch()
                }
                .onChange(of: searchText) {
                    if searchText.isEmpty {
                        onClear()
                    }
                }

            if !searchText.isEmpty {
                Button(action: clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func clearSearch() {
        searchText = ""
        onClear()
        hideKeyboard()
    }
}
