//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI
import Alamofire

struct RecipeView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPresentationDetent: PresentationDetent = .fraction(0.6)
    @State private var sheetPosition: CGFloat = UIScreen.main.bounds.height
    @State private var initialImageFrame: CGRect = .zero
    @State private var sheetPresented = true
    
    let recipe: Recipe
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                GeometryReader { geometryImage in
                    VStack(alignment: .center) {
                        VStack {
                            AsyncImage(
                                url: URL(string: recipe.image),
                                content: { image in
                                    
                                    let computedHeight: CGFloat = geometryImage.size.height * 0.2 + sheetPosition
                                    
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: computedHeight)
                                        .clipped()
                                },placeholder: {})
                        }
                    }
                }
            }
            .sheet(isPresented: $sheetPresented) {
                GeometryReader { sheetGeometry in
                    RecipeDetails(recipe: recipe)
                        .ignoresSafeArea()
                        .presentationCornerRadius(20)
                        .presentationDetents([
                            .fraction(0.9),
                            .fraction(0.6)
                        ], selection: $selectedPresentationDetent)
                        .preference(key: SizePreferenceKey.self, value: sheetGeometry.frame(in: .global).minY)
                        .presentationBackgroundInteraction(
                            .enabled(upThrough: .fraction(0.6))
                        )
                }
                .onPreferenceChange(SizePreferenceKey.self) { preferences in
                    self.sheetPosition = preferences
                }
                .onDisappear(
                    perform: {
                        dismiss()
                    }
                )
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct RecipeDetails: View {
    
    let recipe: Recipe
    @State private var numberOfPersons = 4
    @State private var liked = false
    @State private var nameUser: String = ""
    let URL_CREATE_LIKE = "http://cookbuddy.marcelruhstorfer.de/createLike.php"
    let URL_GET_LIKED_RECIPES = "http://cookbuddy.marcelruhstorfer.de/getRecipesId.php"
    let URL_DELETE_LIKE = "http://cookbuddy.marcelruhstorfer.de/deleteLike.php"
    let URL_GET_NAME = "http://cookbuddy.marcelruhstorfer.de/getUserName.php"
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 16){
            
            VStack (alignment: .leading, spacing: 5) {
                
                Text(recipe.name)
                    .font(.system(size: 20))
                    .bold()
                    .onAppear {
                        getLikes()
                        getUserName()
                    }
                
                HStack{
                    Text("\(nameUser), \(recipe.date)")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundColor(Color(hex: 0xB8B8B8))
                    
                    Spacer()
                    
                    if !recipe.label.isEmpty {
                        Text(recipe.label)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color(hex: 0x007C38))
                                    .opacity(0.9)
                            )
                    }
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 23, height: 20)
                        .foregroundColor(liked ? .red : .black)
                        .onTapGesture {
                            if !liked {
                                createLike()
                            } else {
                                deleteLike()
                            }
                        }
                }
            }
            .padding(.top, 30)
            
            HStack (spacing: 20){
                HStack{
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(Color(hex: 0xB8B8B8))
                    Text((recipe.time ?? "-") + " Min")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: 0xB8B8B8))
                }
                Spacer()
                HStack{
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(Color(hex: 0xB8B8B8))
                    Text(recipe.difficulty ?? "-")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: 0xB8B8B8))
                }
                Spacer()
                HStack{
                    Image(systemName: "flame")
                        .foregroundColor(Color(hex: 0xB8B8B8))
                    Text((recipe.calories ?? "-") + " kcal")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: 0xB8B8B8))
                }
            }
            
            VStack (alignment: .leading, spacing: 5) {
                Text("Beschreibung")
                    .font(.system(size: 20))
                    .bold()
                Text(recipe.description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: 0xB8B8B8))
            }
            
            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    Text("Zutaten")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    HStack (spacing: 0) {
                        Text("Für ")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: 0x5A5A5A))
                        Text("\(numberOfPersons)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: 0x000000))
                            .bold()
                        Text(" Personen")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: 0x5A5A5A))
                    }
                    Stepper("", value: $numberOfPersons, in: 1...10)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: 0xB8B8B8))
                        .labelsHidden()
                }
                
                VStack(alignment: .leading) {
                    ForEach(parseString(recipe.ingredients), id: \.self) { item in
                        CustomBoxView(
                            amount: scaledAmount(amount: item.amount),
                            unit: item.unit,
                            product: item.product
                        )
                    }
                }
                .padding(.top, 10)
            }
            
            VStack (alignment: .leading, spacing: 5) {
                Text("Anleitung")
                    .font(.system(size: 20))
                    .bold()
                Text(recipe.instruction)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: 0xB8B8B8))
            }
            
        }
        .padding(.horizontal, 25)
    }
    
    func scaledAmount(amount: String) -> String {
        guard let originalAmount = Double(amount) else {
            return amount
        }
        
        let scaledAmount = originalAmount * Double(numberOfPersons) / 4.0
        
        if scaledAmount.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", scaledAmount)
        } else {
            return String(format: "%.2f", scaledAmount)
        }
    }
    
    func parseString(_ input: String) -> [ParsedItem] {
        let parts = input.components(separatedBy: ";")
        var result: [ParsedItem] = []
        
        for part in parts {
            let components = part.components(separatedBy: ",")
            if components.count == 2 {
                let item = components[0].components(separatedBy: ":")
                if item.count == 2 {
                    let amount = item[0]
                    let unit = item[1]
                    let product = components[1]
                    result.append(ParsedItem(amount: amount, unit: unit, product: product))
                }
            }
        }
        return result
    }
    
    func isRecipeLiked() {
        if let likedRecipeIDs = UserDefaults.standard.array(forKey: "likedRecipes") as? [Int] {
            if (likedRecipeIDs.contains(recipe.id)) {
                liked = true
            } else {
                liked = false
            }
        } else {
            liked = false
        }
    }
    
    func createLike() {
        let _parameters: Parameters=[
            "user_id":UserDefaults.standard.string(forKey: "id")!,
            "recipe_id":recipe.id
        ]
        
        Alamofire.request(URL_CREATE_LIKE, method: .post, parameters: _parameters).responseJSON{
            response in
            print(response)
            getLikes()
        }
    }
    
    func deleteLike() {
        let _parameters: Parameters=[
            "user_id":UserDefaults.standard.string(forKey: "id")!,
            "recipe_id":recipe.id
        ]
        
        Alamofire.request(URL_DELETE_LIKE, method: .post, parameters: _parameters).responseJSON{
            response in
            print(response)
            getLikes()
        }
    }
    
    func getLikes() {
        let _parameters: Parameters=[
            "user_id":UserDefaults.standard.string(forKey: "id")!
        ]
        
        Alamofire.request(URL_GET_LIKED_RECIPES, method: .post, parameters: _parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let recipesArray = json["recipes"] as? [[String: Any]] {
                    let recipeIDs = recipesArray.compactMap { $0["recipe_id"] as? Int }
                    UserDefaults.standard.set(recipeIDs, forKey: "likedRecipes")
                    isRecipeLiked()
                } else {
                    print("Keine Rezepte mehr geliked!")
                    UserDefaults.standard.set(nil, forKey: "likedRecipes")
                    isRecipeLiked()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getUserName() {
                             
        let parameters: Parameters = ["user_id": recipe.user_id ?? 0]
                             
        Alamofire.request(URL_GET_NAME, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let userName = json["user_name"] as? String {
                        nameUser = userName
                    } else {
                        nameUser = "Unbekannt"
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    nameUser = "Unbekannt"
                }
        }
    }
                         
}

struct ParsedItem: Hashable {
    var id = UUID()
    var amount: String
    var unit: String
    var product: String
}

struct CustomBoxView: View {
    
    let amount: String
    let unit: String
    let product: String
    
    var body: some View {
        HStack {
            HStack {
                Text(product)
                    .font(.system(size: 16))
                    .bold()
                Spacer()
                Text("\(amount) \(unit)")
            }
            .frame(height: 8)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
}
