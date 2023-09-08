//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI
import Alamofire
import PhotosUI

struct HomeView: View {
    
    private let URL_RECIPES = "http://cookbuddy.marcelruhstorfer.de/getRecipes.php"
    private let URL_RECIPES_SEARCH = "http://cookbuddy.marcelruhstorfer.de/getRecipesSearch.php"
    
    @State private var recipes: [Recipe] = []
    @State private var selectedBox: String? = ""
    @State private var displayedImage: Image? = nil
    @State private var isEditingProfileImage = false
    @State private var searchText = ""
    @State private var selectedRecipeID: Int? = 26
    @State private var isLoadingSelectedRecipe = false
    
    @State private var isOverlayPresented = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ScrollView {
                    VStack (spacing: 24) {
                        
                        VStack {
                            
                            Text("Hallo " + (UserDefaults.standard.string(forKey: "user_name") ?? "unbekannter User") + "!")
                                .font(.custom("Ubuntu",fixedSize: 16))
                                .foregroundColor(Color(hex: 0x767676))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 25)
                                .padding(.top, 14)
                            
                            HStack {
                                Text("Was möchtest du heute gerne kochen?")
                                    .foregroundColor(Color(hex: 0x000000))
                                    .bold()
                                    .font(.system(size: 24))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 25)
                                    .multilineTextAlignment(.leading) // Hier kannst du die Ausrichtung anpassen (z.B. .leading, .trailing, .center)
                                    .lineLimit(2) // Dies entfernt die Beschränkung auf die Anzahl der Zeilen
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                
                                ZStack {
                                    if let displayedImage = displayedImage {
                                        displayedImage
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .padding(.horizontal, 25)
                                        
                                        Button(action: {
                                            isOverlayPresented = true
                                        }) {
                                            Image(systemName: "pencil.circle.fill")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.blue)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(radius: 5)
                                        }
                                        .padding(.horizontal, 25)
                                        .offset(x: 25, y: -25)
                                        .onChange(of: isOverlayPresented) { NewValue in
                                            if !NewValue {
                                                getImage()
                                            }
                                        }
                                    } else {
                                        Image("profile")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .padding(.horizontal, 25)
                                            .onTapGesture {
                                                isEditingProfileImage.toggle()
                                            }
                                    }
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
                                            } placeholder: {}
                                            
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
                        
                        Text("Gericht der Woche")
                            .foregroundColor(Color(hex: 0x000000))
                            .bold()
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25)
                        
                        if let selectedRecipe = recipes.first(where: { $0.id == selectedRecipeID }) {
                            NavigationLink(destination: RecipeView(recipe: selectedRecipe)) {
                                SelectedRecipeView(recipe: selectedRecipe)
                                    .padding(.horizontal, 25)
                            }
                        } else {
                            Text("Kein Rezept verfügbar")
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.horizontal, 25)
                        }
                        
                        Spacer()
                        
                    }// Ende VStack
                } // Ende ScrollView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xF2F2F7))
            
        }// Ende NavView
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if searchText.count < 1 {
                getRecipes()
                displayedImage = nil
                getImage()
                loadSelectedRecipe()
            }
        }
        .overlay(
            ProfilePicturePickerOverlay(isPresented: $isOverlayPresented, displayedImage: $displayedImage)
                .opacity(isOverlayPresented ? 1 : 0)
                .animation(.easeInOut(duration: 0.3))
        )
        
    }//Ende Body
    
    func loadSelectedRecipe() {
        let desiredRecipeID = 26
        if let selectedRecipe = recipes.first(where: { $0.id == desiredRecipeID }) {
            selectedRecipeID = desiredRecipeID
        }
    }

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
        HomeView()
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

struct SelectedRecipeView: View {
    var recipe: Recipe

    var body: some View {
        VStack {
            HStack (spacing: 12) {
                
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .cornerRadius(20)
                } placeholder: {}

                VStack(alignment: .center, spacing: 8) {
                    Text(recipe.name)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(Color(hex: 0x000000))

                    Text(recipe.description)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: 0x767676))
                        .multilineTextAlignment(.leading)
                        .lineLimit(8)
                        .padding(.horizontal, 12)
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.white))
        )
    }
}

struct ProfilePicturePickerOverlay: View {
    @Binding var isPresented: Bool
    @Binding var displayedImage: Image?
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var base64String: String?

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                VStack {
                    Text("Profilbild auswählen")
                        .font(.title)
                        .padding()
                    
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                            .padding(.bottom, 18)
                    } else {
                        displayedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                            .padding(.bottom, 18)
                    }
                    
                    VStack (spacing: 12) {
                        PhotosPicker("Neues Profilbild auswählen", selection: $avatarItem, matching: .images)
                            .onChange(of: avatarItem) { _ in
                                Task {
                                    if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            avatarImage = Image(uiImage: uiImage)
                                            return
                                        }
                                    }
                                }
                            }
                            .font(.custom("Ubuntu-Bold", size: 17))
                            .foregroundColor(Color(hex: 0xFFFFFF))
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color(hex: 0x007C38))
                            .cornerRadius(14)
                            .shadow(radius: 4, x: 0, y: 5)
                    
                        Button(action: {
                            let image = avatarImage
                            let size = CGSize(width: 100, height: 100)
                            
                            let uiImage = image!.getUIImage(newSize: size)
                            let imageData = uiImage!.pngData()
                            base64String = imageData!.base64EncodedString()
                            
                            UserDefaults.standard.set(base64String, forKey: "picture")
                            
                            addPicture()
            
                            isPresented = false
                        }) {
                            Text("Bild speichern")
                                .font(.custom("Ubuntu-Bold", size: 17))
                                .foregroundColor(Color(hex: 0xFFFFFF))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .background(Color(hex: 0x007C38))
                        .cornerRadius(14)
                        .shadow(radius: 4, x: 0, y: 5)

                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Abbrechen")
                                .font(.custom("Ubuntu-Bold", size: 17))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        }
                        .background(Color.red)
                        .cornerRadius(14)
                        .shadow(radius: 4, x: 0, y: 5)
                    }
                    .padding(.bottom, 24)
                    
                }
                .padding(.horizontal, 25)
                .background(Color.white)
                .cornerRadius(20)
            }
            .padding(.horizontal, 25)
        }
        .onTapGesture {
            isPresented = false
        }
    }
    
    private func addPicture() {
        
        let URL_ADD_PICTURE = "http://cookbuddy.marcelruhstorfer.de/addPicture.php"
        
        let _parameters: Parameters=[
            "id":UserDefaults.standard.string(forKey: "id")!,
            "picture": base64String!
        ]
        
        Alamofire.request(URL_ADD_PICTURE, method: .post, parameters: _parameters).responseJSON{
            response in
            print(response)
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                if ((jsonData.value(forKey: "message") as! String) == "Profile Picture added successfully")
                {
                    avatarImage = nil
                    avatarItem = nil
                }
            }
        }
    }
}

extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
