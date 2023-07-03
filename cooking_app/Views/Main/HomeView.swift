//
//  HomeView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                RecipeList(recipes: Recipe.all)
            }
            .navigationTitle("Meine Rezepte")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

