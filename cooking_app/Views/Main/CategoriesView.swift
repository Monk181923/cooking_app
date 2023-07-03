//
//  CategoriesView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI

struct CategoriesView: View {
    var body: some View {
        NavigationView {
            Text("Kategorie")
                .navigationTitle("Kategorie")
        }
        .navigationViewStyle(.stack)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
