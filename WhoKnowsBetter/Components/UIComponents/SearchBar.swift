//
//  SearchBar.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 22.03.2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchString: String
    @FocusState var isFocused: Bool
    var placeHolder: String = "Search..."
    var body: some View {
        HStack {
            Spacer().frame(width: 40)
            Image(systemName: "magnifyingglass")
            TextField(placeHolder, text: $searchString)
                .textInputAutocapitalization(.never).focused($isFocused)
            Spacer().frame(width: 50)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    func getSearcString() -> String {
        return self.searchString
    }
}
