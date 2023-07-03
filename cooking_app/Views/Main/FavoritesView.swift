//
//  FavoritesView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            Text("Du hast aktuell keine Favoriten")
                .padding()
                .navigationTitle("Favoriten")
        }
        .navigationViewStyle(.stack)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
