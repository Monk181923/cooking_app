//
//  NewRecipeView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI
import Alamofire

struct NewRecipeView: View {
    
    @State private var category = "Hauptgericht"
    @State private var label = ""
    @State private var image = ""
    @State private var name = ""
    @State private var description = ""
    @State private var date = ""
    @State private var ingredients = ""
    @State private var instruction = ""
    
    let categorys = ["Salat", "Suppe", "Vorspeise", "Hauptgericht", "Dessert", "Snack"]
    let URL_CREATE_RECIPE = "http://cookbuddy.marcelruhstorfer.de/createRecipe.php"
    
    var body: some View {
        VStack (spacing: 24) {
            
            Picker("Wähle eine Kategorie", selection: $category) {
                ForEach(categorys, id: \.self) {
                    Text($0)
                }
            }
            .frame(width: .infinity, height: 38)
            .pickerStyle(.menu)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .background(Color(hex: 0xFAFAFA))
            
            TextField("Label",
                      text: $label,
                      prompt: Text("Label (Vegan, Vegetarisch, ...)")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            TextField("Image",
                      text: $image,
                      prompt: Text("Image (URL)")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            TextField("Name",
                      text: $name,
                      prompt: Text("Name des Rezeptes")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            TextField("Beschreibung",
                      text: $description,
                      prompt: Text("Beschreibung")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            TextField("Zutaten",
                      text: $ingredients,
                      prompt: Text("Zutaten")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            TextField("Anleitung",
                      text: $instruction,
                      prompt: Text("Anleitung (1. Schritt; 2. Schritt; ...")
                .foregroundColor(Color(hex: 0x9C9C9C))
                .font(.custom("Ubuntu-Regular",fixedSize: 17)))
            .frame(maxHeight: 38)
            .padding(10)
            .background(Color(hex: 0xFAFAFA))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
            }
            .padding(.horizontal, 25)
            
            Button {
                createRecipe()
            } label: {
                Text("Rezept erstellen")
                    .font(.custom("Ubuntu-Bold", size: 17))
                    .foregroundColor(Color(hex: 0xFFFFFF))
                    .frame(maxWidth: .infinity, maxHeight: 54)
            }
            .background(Color(hex: 0x007C38))
            .cornerRadius(14)
            .shadow(radius: 4, x: 0, y: 5)
            .padding(.horizontal, 25)
        }
    }
    
    func createRecipe() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let formattedDate = dateFormatter.string(from: currentDate)
        
        if ((category != "") && (label != "") && (image != "") && (name != "") && (description != "") && (ingredients != "") && (instruction != "")) {
            
            let _parameters: Parameters=[
                "category":category,
                "label":label,
                "image":image,
                "name":name,
                "date":formattedDate,
                "description":description,
                "ingredients":ingredients,
                "instruction":instruction
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
                    }
                }
            }
        }
    }
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
    }
}
