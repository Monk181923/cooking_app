//
//  HomeView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI
import Alamofire

struct HomeView: View {
    
    let URL_RECIPES = "http://cookbuddy.marcelruhstorfer.de/getRecipes.php"
    @State private var recipes: [Recipe] = []
    @State private var selectedBox: String? = "Vegetarisch"
    @State private var displayedImage: Image? = nil
    
    var body: some View {
        NavigationView {
            VStack (spacing: 24) {
                
                VStack {
                    Text("Hallo " + (UserDefaults.standard.string(forKey: "user_name") ?? "unbekannter User") + "!")
                        .font(.custom("Ubuntu",fixedSize: 14))
                        .foregroundColor(Color(hex: 0x767676))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .padding(.top, 18)
                    
                    HStack {
                        Text("Was möchtest du heute gerne kochen?")
                            .foregroundColor(Color(hex: 0x000000))
                            .bold()
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25)
                        
                        displayedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                        
                        if displayedImage == nil {
                            Image("profile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding(.horizontal, 25)
                        }
                        
                    }
                }
            
                
                Text("Kategorien")
                    .foregroundColor(Color(hex: 0x000000))
                    .bold()
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        CustomBox(iconName: "carrot", text: "Vegetarisch", isSelected: selectedBox == "Vegetarisch")
                            .onTapGesture {
                                selectedBox = "Vegetarisch"
                            }
                        CustomBox(iconName: "seedling", text: "Vegan", isSelected: selectedBox == "Vegan")
                            .onTapGesture {
                                selectedBox = "Vegan"
                            }
                        CustomBox(iconName: "salad", text: "Salat", isSelected: selectedBox == "Salat")
                            .onTapGesture {
                                selectedBox = "Salat"
                            }
                        CustomBox(iconName: "soup", text: "Vorspeise", isSelected: selectedBox == "Vorspeise")
                            .onTapGesture {
                                selectedBox = "Vorspeise"
                            }
                        CustomBox(iconName: "pasta", text: "Hauptgericht", isSelected: selectedBox == "Hauptgericht")
                            .onTapGesture {
                                selectedBox = "Hauptgericht"
                            }
                        CustomBox(iconName: "pudding", text: "Dessert", isSelected: selectedBox == "Dessert")
                            .onTapGesture {
                                selectedBox = "Dessert"
                            }
                        CustomBox(iconName: "popcorn", text: "Snack", isSelected: selectedBox == "Snack")
                            .onTapGesture {
                                selectedBox = "Snack"
                            }
                    }
                    .padding(.horizontal, 25)
                }
                
                Text("Empfehlungen")
                    .foregroundColor(Color(hex: 0x000000))
                    .bold()
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                
                List(recipes) { recipe in
                    NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.description)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .background(Color(hex: 0xF2F2F7))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            getRecipes()
            displayedImage = nil
            getImage()
        }
    }//Ende Body

    func getImage() {
    
        if let base64String = UserDefaults.standard.value(forKey: "picture") as? String {
            if let imageData = Data(base64Encoded: base64String) {
                if let uiImage = UIImage(data: imageData) {
                    displayedImage = Image(uiImage: uiImage)
                }
            }
        }
        
    }
    
    func getRecipes() {
        Alamofire.request(URL_RECIPES, method: .get).responseJSON { response in
            switch response.result {
            case .success(let jsonData):
                do {
                    guard let jsonDict = jsonData as? [String: Any],
                          let recipesJSON = jsonDict["recipes"] as? [[String: Any]] else {
                        print("Error: Invalid JSON structure")
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
                print("Error fetching recipes: \(error)")
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct RecipeDetail: View {
    let recipe: Recipe

    var body: some View {
        VStack {
            Text(recipe.name)
                .font(.title)
            Text(recipe.description)
                .font(.body)
            Text(recipe.category)
                .font(.body)
            Text(recipe.label)
                .font(.body)
            Text(recipe.date)
                .font(.body)
            Text(recipe.image)
                .font(.body)
            Text(recipe.ingredients)
                .font(.body)
            Text(recipe.instruction)
                .font(.body)
            Text(String(recipe.id))
                .font(.body)
        }
        .navigationBarTitle(recipe.name)
    }
}

struct CustomBox: View {
    var iconName: String
    var text: String
    var isSelected: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(isSelected ? Color(hex: 0x007C38) : Color(hex: 0xFFFFFF))
            .frame(width: 80, height: 80)
            .overlay(VStack {
                
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isSelected ? .white : .blue)
                    .padding(.top, 10)
                        
                Text(text)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color(hex: 0xFFFFFF) : Color(hex: 0xAFAFAF))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity)
            })
    }
}
