//
//  NewRecipeView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI
import Alamofire
import PhotosUI

struct NewRecipeView: View {
    
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
    @State private var calories = ""
    
    @State private var isVeganChecked = false
    @State private var isVegetarianChecked = false
    
    @State private var recipeItem: PhotosPickerItem?
    @State private var recipeImage: Image?
    @State private var uiImageF: UIImage?
    
    @State private var cookingDuration: Int = 0
    
    let categorys = ["Salat", "Suppe", "Vorspeise", "Hauptgericht", "Dessert", "Snack"]
    let labels = ["Vegan", "Vegetarisch"]
    let difficulties = ["Leicht", "Mittel", "Schwer"]
    let URL_CREATE_RECIPE = "http://cookbuddy.marcelruhstorfer.de/createRecipe.php"
    
    var body: some View {
        VStack (spacing: 24) {
            
            VStack (alignment: .leading, spacing: 24) {
                
                HStack {
                    Picker("Wähle eine Kategorie", selection: $category) {
                        ForEach(categorys, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
                    .background(Color(hex: 0xFAFAFA))
                    
                    Spacer()
                    
                    Picker("Schwierigkeit", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
                    .background(Color(hex: 0xFAFAFA))
                }
                
                
                VStack (alignment: .leading) {
                    HStack {
                        CheckBoxView(isChecked: $isVeganChecked, text: "Vegan")
                        Spacer()
                        CheckBoxView(isChecked: $isVegetarianChecked, text: "Vegetarisch")
                    }
                }
                .onChange(of: isVeganChecked) { newValue in
                            if newValue {
                                label = "vegan"
                                isVegetarianChecked = false
                            } else if !isVegetarianChecked {
                                label = ""
                            }
                            print(label)
                        }
                        .onChange(of: isVegetarianChecked) { newValue in
                            if newValue {
                                label = "vegetarisch"
                                isVeganChecked = false
                            } else if !isVeganChecked {
                                label = ""
                            }
                            print(label)
                        }
                
                TextField("Name",
                          text: $name,
                          prompt: Text("Name des Rezeptes")
                    .foregroundColor(Color(hex: 0x9C9C9C))
                    .font(.custom("Ubuntu-Regular",fixedSize: 17)))
                .frame(maxHeight: 20)
                .padding(10)
                .background(Color(hex: 0xFAFAFA))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                }
            }
            
            TextField("Beschreibung",
                      text: $description,
                      prompt: Text("Beschreibung")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 20)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            
            VStack {
                        
                HStack {
                    Button(action: {
                        if let currentDuration = Int(time) {
                            self.cookingDuration = max(currentDuration - 5, 0)
                            self.time = String(self.cookingDuration)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                    }
                            
                    Spacer()
                    
                    Text("Kochdauer: \(cookingDuration) Minuten")
                    .font(.headline)
                    
                    Spacer()
                            
                    Button(action: {
                        if let currentDuration = Int(time) {
                            self.cookingDuration = currentDuration + 5
                            self.time = String(self.cookingDuration)
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                    }
                }
            }
            
            TextField("Kalorien (4 Personen)",
                      text: $calories,
                      prompt: Text("Kalorien (4 Personen)")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 20)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            
            TextField("Zutaten",
                      text: $ingredients,
                      prompt: Text("Zutaten")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 20)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            
            TextField("Anleitung",
                      text: $instruction,
                      prompt: Text("Anleitung (1. Schritt; 2. Schritt; ...")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 20)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            
            Button {
                print("Rezept erstellen gedrückt")
                print(label + "," + difficulty + "," + time)
                /*
                if let inputImage = uiImageF {
                    if let imageData = inputImage.jpegData(compressionQuality: 0.5) {
                        uploadImage(imageData: imageData) { result in
                            switch result {
                            case .success(let imageURL):
                                print("Image uploaded successfully. URL: \(imageURL)")
                                image = imageURL
                                createRecipe()
                            case .failure(let error):
                                print("Image upload failed. Error: \(error)")
                                image = "ERROR"
                            }
                        }
                    }
                }
                 */
            } label: {
                Text("Rezept erstellen")
                    .font(.custom("Ubuntu-Bold", size: 17))
                    .foregroundColor(Color(hex: 0xFFFFFF))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color(hex: 0x007C38))
            .cornerRadius(14)
            .shadow(radius: 4, x: 0, y: 5)
            
            VStack {
                
                PhotosPicker("Select avatar", selection: $recipeItem, matching: .images)
                
                if let recipeImage {
                    recipeImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
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
        }.padding(.horizontal, 25)
    }
    
    func createRecipe() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let formattedDate = dateFormatter.string(from: currentDate)
        
        if ((category != "") && (label != "") && (image != "") && (name != "") && (description != "") && (ingredients != "") && (instruction != "") && (difficulty != "") && (time != "") && (calories != "")) {
            
            let _parameters: Parameters=[
                "category":category,
                "label":label,
                "image":image,
                "name":name,
                "date":formattedDate,
                "description":description,
                "ingredients":ingredients,
                "instruction":instruction,
                "difficulty":difficulty,
                "time":time,
                "calories":calories
            ]
            
            Alamofire.request(URL_CREATE_RECIPE, method: .post, parameters: _parameters).responseJSON{
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    if ((jsonData.value(forKey: "message") as! String) == "Recipe created successfully")
                    {
                        category=""
                        label=""
                        image=""
                        name=""
                        description=""
                        ingredients=""
                        instruction=""
                        difficulty=""
                        time=""
                        calories=""
                    }
                }
            }
        }
    }
    
    func uploadImage(imageData: Data, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let url = "http://cookbuddy.marcelruhstorfer.de/imageUpload.php"
        let validName = name.replacingOccurrences(of: " ", with: "_")

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: validName + ".jpg", mimeType: "image/jpeg")
        }, to: url) { result in
            switch result {
            case .success(let uploadRequest, _, _):
                uploadRequest.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let imageURL = (value as? [String: Any])?["imageURL"] as? String {
                            completion(.success(imageURL))
                        } else {
                            completion(.failure(NSError(domain: "Response error", code: 0, userInfo: nil)))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
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
                Text(text)
            }
        }
        
    }
}
