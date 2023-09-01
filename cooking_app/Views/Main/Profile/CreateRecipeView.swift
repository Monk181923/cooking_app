//
//  CreateRecipeView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 23.08.23.
//

import SwiftUI
import Alamofire
import PhotosUI

struct CreateRecipeView: View {
    
    @State private var category = "Hauptgericht"
    @State private var label = ""
    @State private var image = ""
    @State private var name = ""
    @State private var description = ""
    @State private var date = ""
    @State private var ingredients = ""
    @State private var instruction = ""
    @State private var difficulty = "Leicht"
    @State private var time = "0"
    @State private var calories = "450"
    
    @State private var uiImageF: UIImage?
    
    let URL_CREATE_RECIPE = "http://cookbuddy.marcelruhstorfer.de/createRecipe.php"
    
    @State private var currentPageIndex = 2
    
    var body: some View {
        VStack {
            TabView(selection: $currentPageIndex) {
                NameSelectionPage(currentPageIndex: $currentPageIndex, name: $name, description: $description, uiImageF: $uiImageF)
                    .tag(0)
                DetailSelectionPage(currentPageIndex: $currentPageIndex, category: $category, label: $label, difficulty: $difficulty, time: $time, calories: $calories)
                    .tag(1)
                instructionSelectionPage(currentPageIndex: $currentPageIndex, ingredients: $ingredients)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            ProgressDots(currentPageIndex: currentPageIndex, pageCount: 6)
                .padding(.vertical)
        }
        .background(Color(hex: 0xF2F2F7))
    }
}


struct NameSelectionPage: View {
    @Binding var currentPageIndex: Int
    @Binding var name: String
    @Binding var description: String
    @Binding var uiImageF: UIImage?

    @State private var recipeItem: PhotosPickerItem?
    @State private var recipeImage: Image?
    
    init(currentPageIndex: Binding<Int>, name: Binding<String>, description: Binding<String>, uiImageF: Binding<UIImage?>) {
        self._currentPageIndex = currentPageIndex
        self._name = name
        self._description = description
        self._uiImageF = uiImageF
    }
    
    var body: some View {
        VStack (spacing: 24) {
            
            VStack {
                VStack {
                    Text("Name des Rezeptes:")
                        .foregroundColor(Color(hex: 0x000000))
                        .bold()
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("Name",
                              text: $name,
                              prompt: Text("Name des Rezeptes")
                                  .foregroundColor(Color(hex: 0x9C9C9C))
                                  .font(.custom("Ubuntu-Regular", fixedSize: 17))
                        )
                        .frame(maxHeight: 20)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .onChange(of: name) { newName in
                            if newName.count > 90 {
                                name = String(newName.prefix(90))
                            }
                        }
                }
                
                VStack {
                    Text("Beschreibung:")
                        .foregroundColor(Color(hex: 0x000000))
                        .bold()
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextEditor(text: $description)
                        .foregroundColor(Color(hex: 0x9C9C9C))
                        .font(.custom("Ubuntu-Regular", fixedSize: 17))
                        .frame(height: 100) // Höhe nach Bedarf anpassen
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .onChange(of: description) { newText in
                            if newText.count > 500 {
                                description = String(newText.prefix(500))
                            }
                        }

                    // Anzeige der verbleibenden Zeichen
                    HStack {
                        Spacer()
                        Text("\(500 - description.count) Zeichen übrig")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            
            
            VStack {
                
                Text("Bild des Gerichtes:")
                    .foregroundColor(Color(hex: 0x000000))
                    .bold()
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let recipeImage {
                    recipeImage
                        .resizable()
                        .frame(height: 200)
                        .aspectRatio(contentMode: .fit)
                    
                    PhotosPicker("Anderes Bild auswählen", selection: $recipeItem, matching: .images)
                        .foregroundColor(Color(hex: 0x007C38))
                } else {
                    PhotosPicker("Bild auswählen", selection: $recipeItem, matching: .images)
                        .padding(.vertical, 25)
                        .frame(height: 200)
                        .foregroundColor(Color(hex: 0x007C38))
                }
            }
            .onChange(of: recipeItem) { _ in
                Task {
                    if let data = try? await recipeItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            recipeImage = Image(uiImage: uiImage)
                            uiImageF = uiImage
                            return
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            
            Button {
                withAnimation {
                    currentPageIndex = 1
                }
            } label: {
                Text("Weiter")
                    .font(.custom("Ubuntu-Bold", size: 17))
                    .foregroundColor(Color(hex: 0xFFFFFF))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color(hex: 0x007C38))
            .cornerRadius(14)
            .shadow(radius: 4, x: 0, y: 5)
            
        }
        .padding(.horizontal, 25)
    }
}

struct DetailSelectionPage: View {
    @Binding var currentPageIndex: Int
    @Binding var category: String
    @Binding var label: String
    @Binding var difficulty: String
    @Binding var time: String
    @Binding var calories: String

    @State private var isVeganChecked = false
    @State private var isVegetarianChecked = false
    @State private var cookingDuration: Int = 0

    let minCalories: Double = 50
    let maxCalories: Double = 2000
    
    let categorys = ["Salat", "Suppe", "Vorspeise", "Hauptgericht", "Dessert", "Snack"]
    let labels = ["Vegan", "Vegetarisch"]
    let difficulties = ["Leicht", "Mittel", "Schwer"]
    
    init(currentPageIndex: Binding<Int>, category: Binding<String>, label: Binding<String>, difficulty: Binding<String>, time: Binding<String>, calories: Binding<String>) {
        self._currentPageIndex = currentPageIndex
        self._category = category
        self._label = label
        self._difficulty = difficulty
        self._time = time
        self._calories = calories

    }
    
    var body: some View {
        
        VStack (spacing: 24) {
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Kategorie:")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Picker("Wähle eine Kategorie", selection: $category) {
                        ForEach(categorys, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(Color(hex: 0x007C38))
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
                    .background(Color(hex: 0xFAFAFA))
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Schwierigkeit:")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Picker("Schwierigkeit", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(Color(hex: 0x007C38))
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
                    .background(Color(hex: 0xFAFAFA))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )


            VStack(alignment: .leading, spacing: 20) {
                Text("Besonderheiten:")
                    .font(.headline)
                    .foregroundColor(.black)
                
                CheckBoxView(isChecked: $isVeganChecked, text: "Vegan")
                CheckBoxView(isChecked: $isVegetarianChecked, text: "Vegetarisch")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .onChange(of: isVeganChecked) { newValue in
                if newValue {
                    label = "vegan"
                    isVegetarianChecked = false
                } else if !isVegetarianChecked {
                    label = ""
                }
            }
            .onChange(of: isVegetarianChecked) { newValue in
                if newValue {
                    label = "vegetarisch"
                    isVeganChecked = false
                } else if !isVeganChecked {
                    label = ""
                }
            }
            
            VStack(spacing: 20) {
                Text("Kochdauer:")
                    .font(.headline)
                    .foregroundColor(.black)
                
                HStack {
                    Spacer()
                    Button(action: {
                        if let currentDuration = Int(time) {
                            self.cookingDuration = max(currentDuration - 5, 0)
                            self.time = String(self.cookingDuration)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                            .foregroundColor(Color(hex: 0x007C38))
                    }

                    Text("\(cookingDuration) Minuten")
                        .font(.headline)
                    
                    Button(action: {
                        if let currentDuration = Int(time) {
                            self.cookingDuration = currentDuration + 5
                            self.time = String(self.cookingDuration)
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(Color(hex: 0x007C38))
                    }
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )

            VStack(spacing: 20) {
                Text("Wähle die Kalorien aus")
                    .font(.headline)
                    .foregroundColor(.black)
                    
                Slider(value: Binding(get: {
                    Double(calories) ?? minCalories
                }, set: { newValue in
                    calories = String(Int(newValue))
                }), in: minCalories...maxCalories, step: 5)
                .accentColor(Color(hex: 0x007C38))
                .padding(.horizontal, 20)
                
                Text("\(calories) kcal") // Verwende die calories-Variable hier
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
        
            
            
            Button {
                withAnimation {
                    currentPageIndex = 2
                }
            } label: {
                Text("Weiter")
                    .font(.custom("Ubuntu-Bold", size: 17))
                    .foregroundColor(Color(hex: 0xFFFFFF))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color(hex: 0x007C38))
            .cornerRadius(14)
            .shadow(radius: 4, x: 0, y: 5)
        
        }
        .padding(.horizontal, 25)
    }
}

struct instructionSelectionPage: View {
    @Binding var currentPageIndex: Int
    @Binding var ingredients: String
    
    @State private var objects: [Ingredient] = [Ingredient()]
    @State private var steps: [Steps] = [Steps()]
    
    init(currentPageIndex: Binding<Int>, ingredients: Binding<String>) {
        self._currentPageIndex = currentPageIndex
        self._ingredients = ingredients
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Zutaten:")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 12)
                        .padding(.horizontal, 25)
                    VStack {
                        ForEach(objects.indices, id: \.self) { index in
                            ObjectRow(object: $objects[index], objects: $objects)
                                .padding(4)
                        }
                        Button(action: {
                            if !objects.contains(where: { $0.ingredient.isEmpty }) {
                                objects.append(Ingredient())
                            }
                        }) {
                            Text("Weitere Zutat hinzufügen")
                                .accentColor(Color(hex: 0x007C38))
                        }
                        .disabled(objects.contains { $0.ingredient.isEmpty })
                        
                        Text(formattedIngredients())
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                )
                
                VStack (alignment: .leading) {
                    Text("Kochanleitung")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 12)
                        .padding(.horizontal, 25)
                    
                    VStack {
                        ForEach(steps.indices, id: \.self) { index in
                            StepRow(step: $steps[index], steps: $steps)
                                .padding(4)
                        }
                        
                        Button(action: {
                            steps.append(Steps())
                        }) {
                            Text("Weiteren Schritt hinzufügen")
                                .accentColor(Color(hex: 0x007C38))
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
            .padding(.horizontal, 25)
        }
    }
    
    struct StepRow: View {
        @Binding var step: Steps
        @Binding var steps: [Steps]
        
        var body: some View {
            VStack {
                Text("Schritt \(steps.firstIndex(where: { $0.id == step.id })! + 1)")
                    .font(.headline)
                
                TextEditor(text: $step.step)
                    .foregroundColor(Color(hex: 0x9C9C9C))
                    .font(.custom("Ubuntu-Regular", fixedSize: 17))
                    .frame(height: 100) // Höhe nach Bedarf anpassen
                    .padding(10)
                    .background(Color(hex: 0xFAFAFA))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
            }
        }
    }

    struct ObjectRow: View {
        @Binding var object: Ingredient
        @Binding var objects: [Ingredient]
        
        let units = ["g", "kg", "EL", "TL", "ml", "Liter", "Prise"]

        var body: some View {
            VStack {
                HStack {
                    TextField("Zutat", text: $object.ingredient)
                        .font(.system(size: 16))
                        .bold()
                    Spacer()
                    HStack {
                        TextField("Menge", text: $object.amount)
                            .multilineTextAlignment(.trailing)
                            .fixedSize(horizontal: true, vertical: false)
                        Picker("Einheit", selection: $object.unit) {
                            ForEach(units, id: \.self) {
                                Text($0)
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color(hex: 0x007C38))
                    }
                    if objects.count > 1 { // Nur wenn es mehr als ein Element gibt
                        Button(action: {
                            objects.removeAll { $0.id == object.id }
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                    }
                }
                .frame(height: 8)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
        }
    }
    
    func formattedIngredients() -> String {
        var result = ""
        
        for object in objects {
            if !object.ingredient.isEmpty && !object.amount.isEmpty && !object.unit.isEmpty {
                if !result.isEmpty {
                    result += ";"
                }
                
                result += "\(object.amount):\(object.unit),\(object.ingredient)"
            }
        }
        
        return result
    }
}

struct Ingredient: Identifiable, Equatable {
    var id = UUID()
    var ingredient: String = ""
    var amount: String = ""
    var unit: String = "g"
}
    
struct Steps: Identifiable, Equatable {
    var id = UUID()
    var step: String = ""
}

struct ProgressDots: View {
    let currentPageIndex: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == currentPageIndex ? Color(hex: 0x007C38) : Color.white)
            }
        }
    }
}

struct NewRecipePage_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}

struct CheckBoxView: View {
    
    @Binding var isChecked: Bool
    let text: String
    
    var body: some View {
        
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(Color(hex: 0x007C38))
                Text(text)
                    .foregroundColor(Color(hex: 0x007C38))
            }
        }
        
    }
}
