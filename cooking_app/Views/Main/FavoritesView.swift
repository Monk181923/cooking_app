//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI
import Alamofire

struct FavoritesView: View {
    
    private let URL_FAV_RECIVES = "http://cookbuddy.marcelruhstorfer.de/getLikedRecipes.php"
    @State private var recipes: [Recipe] = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if recipes.isEmpty {
                        Text("Du hast noch keine Favoriten gespeichert!")
                    } else {
                        ScrollView {
                            Text("Favoriten")
                                .foregroundColor(Color(hex: 0x000000))
                                .bold()
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 25)
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(recipes) { recipe in
                                    NavigationLink(destination: RecipeView(recipe: recipe)) {
                                        RoundedBoxView(recipe: recipe)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: 0xF2F2F7))
            }
            .onAppear(perform: {
                getRecipesSearch()
            })
            .navigationViewStyle(.stack)
        }
    }
    
    func getRecipesSearch() {
        let likedRecipes = UserDefaults.standard.array(forKey: "likedRecipes") as? [Int] ?? []
        print (likedRecipes)
        
        let parameters: [String: Any] = [
            "recipes_id": likedRecipes
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(URL_FAV_RECIVES, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                do {
                    guard let jsonDict = jsonData as? [String: Any],
                          let recipesJSON = jsonDict["recipes"] as? [[String: Any]] else {
                        print("Error: Invalid JSON structure")
                        self.recipes = []
                        return
                    }
                    
                    let data = try JSONSerialization.data(withJSONObject: recipesJSON)
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode([Recipe].self, from: data)
                    self.recipes = recipes
                } catch {
                    print("Error decoding recipes: \(error)")
                }
            case .failure(let error):
                print("Vermutlich keine Netzverbindung")
                print("Error fetching recipes: \(error)")
            }
        }
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

struct RecipeDetail: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            Text(recipe.name)
        }
        .navigationBarTitle(recipe.name)
    }
}

struct RoundedBoxView: View {
    
    var recipe: Recipe
    
    var body: some View {
        
        VStack {
            
            AsyncImage(url: URL(string: recipe.image)) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .cornerRadius(20)
            } placeholder: {}
            
            Text(recipe.name)
                .font(.system(size: 18))
                .bold()
                .foregroundColor(Color(hex: 0x000000))
                .padding(.top, 5)
                .frame(maxWidth: 150, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
        }
    }
}
