//
//  RecipeModel.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import Foundation

enum Category: String {
    case frühstück = "Frühstück"
    case suppe = "Suppe"
    case salat = "Salat"
    case vorspeise = "Vorspeise"
    case Hauptmahlzeit = "Hauptmahlzeit"
    case dessert = "Dessert"
    case trinken = "Trinken"
}

enum Typ: String {
    case vegetarsich = "Vegetarisch"
    case vegan = "Vegan"
    case lowcarp = "Low Carp"
    case hightprotein = "High Protein"
    case normal = "Normal"
}

struct Recipe: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let description: String
    let ingredents: String
    let category: Category.RawValue
    let typ: Typ.RawValue
    let datePublished: String
}

extension Recipe {
    static let all: [Recipe] = [
        Recipe(image: "file:///Users/vislab-rechner-1212700/Desktop/oreo%20kuchen.html", name: "Oreo Cake", description: "Sehr Lecker", ingredents: "Zucker, Kekse", category: "Dessert", typ: "Normal", datePublished: "10.10.2010"),
        Recipe(image: "https://www.chefkoch.de/rezepte/3079351460583513/Flexibles-Muffin-Rezept-fuer-12-Muffins.html", name: "Muffins", description: "Lecker", ingredents: "Zucker, Fett", category: "Dessert", typ: "Vegan", datePublished: "11.11.2011"),
        Recipe(image: "https://www.kochbar.de/rezept/40041/Tiramisu.html", name: "Tiramisu", description: "Lecker", ingredents: "Zucker, Fett", category: "Dessert", typ: "Vegan", datePublished: "11.11.2011"),
        Recipe(image: "https://www.gutekueche.at/karottensuppe-rezept-8022", name: "Gemüsebrei", description: "Lecker", ingredents: "Zucker, Fett", category: "Dessert", typ: "Vegan", datePublished: "11.11.2011"),
        Recipe(image: "https://www.gutekueche.at/karottensuppe-rezept-8022", name: "Karottensuppe", description: "Lecker", ingredents: "Zucker, Fett", category: "Dessert", typ: "Vegan", datePublished: "11.11.2011")
    
    ]
}
