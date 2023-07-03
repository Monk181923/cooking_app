//
//  RecipeList.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 19.06.23.
// list all recipes

import SwiftUI

struct RecipeList: View {
    var recipes: [Recipe]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(recipes.count) \(recipes.count > 1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(recipes) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
            .padding(.top)
            
        }
            .padding(.horizontal)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RecipeList(recipes: Recipe.all)
        }
    }
}
