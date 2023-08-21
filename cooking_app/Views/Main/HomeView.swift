//
//  HomeView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI
import Alamofire

struct HomeView: View {
    
    private let URL_RECIPES = "http://cookbuddy.marcelruhstorfer.de/getRecipes.php"
    private let URL_RECIPES_SEARCH = "http://cookbuddy.marcelruhstorfer.de/getRecipesSearch.php"
    @State private var recipes: [Recipe] = []
    @State private var selectedBox: String? = ""
    @State private var displayedImage: Image? = nil
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            
            VStack (spacing: 24) {
                
                VStack {
                    Text("Hallo " + (UserDefaults.standard.string(forKey: "user_name") ?? "unbekannter User") + "!")
                        .font(.custom("Ubuntu",fixedSize: 16))
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
                            .padding(.leading, 25)
                            .multilineTextAlignment(.leading) // Hier kannst du die Ausrichtung anpassen (z.B. .leading, .trailing, .center)
                            .lineLimit(3) // Dies entfernt die Beschränkung auf die Anzahl der Zeilen
                            .fixedSize(horizontal: false, vertical: true)

                        
                        displayedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                        
                        if displayedImage == nil {
                            Image("profile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .padding(.horizontal, 25)
                        }
                        
                    }
                }
                
                SearchBar(text: $searchText)
                
                Text("Kategorien")
                    .foregroundColor(Color(hex: 0x000000))
                    .bold()
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        CustomBox(iconName: "dinner", text: "Alles", isSelected: selectedBox == "")
                            .onTapGesture {
                                selectedBox = ""
                            }
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                            ForEach(recipes.filter { recipe in
                                switch selectedBox {
                                case "":
                                    return true
                                case "Vegetarisch":
                                    return recipe.label == "Vegetarisch" || recipe.label == "Vegan"
                                case "Vegan":
                                    return recipe.label == "Vegan"
                                case "Salat":
                                    return recipe.category == "Salat"
                                case "Vorspeise":
                                    return recipe.category == "Vorspeise"
                                case "Hauptgericht":
                                    return recipe.category == "Hauptgericht"
                                case "Dessert":
                                    return recipe.category == "Dessert"
                                case "Snack":
                                    return recipe.category == "Snack"
                                default:
                                    return false
                                }
                            }, id: \.id) { recipe in
                                NavigationLink(destination: RecipeView(recipe: recipe)) {
                                VStack {
                                    AsyncImage(url: URL(string: recipe.image)) {
                                        image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 200)
                                                .cornerRadius(20)
                                    } placeholder: {
                                        Image(recipe.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 200)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                    }

                                    Text(recipe.name)
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(Color(hex: 0x000000))
                                        .padding(.top, 5) // Abstand zwischen Bild und Name
                                        .frame(maxWidth: 150, alignment: .leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.bottom, 20)
                .onChange(of: searchText) { newValue in
                    if newValue.count > 0 {
                        getRecipesSearch()
                        displayedImage = nil
                        getImage()
                    }
                    else {
                        getRecipes()
                        displayedImage = nil
                        getImage()
                    }
                }
            }
            .background(Color(hex: 0xF2F2F7))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if searchText.count < 1 {
                getRecipes()
                displayedImage = nil
                getImage()
            }
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
    
    func getRecipesSearch() {
        let _parameters: Parameters=[
            "searchTerm":searchText
        ]
        
        Alamofire.request(URL_RECIPES_SEARCH, method: .post, parameters: _parameters).responseJSON{
            response in
            print(response)
            
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
                print("Vermutlich keine Netzverbindung")
                print("Error fetching recipes: \(error)")
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray))
                .padding(.leading, 14)
            
            TextField("Suche nach Rezepten", text: $text)
                .padding(8)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.white))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 25)
    }
}
