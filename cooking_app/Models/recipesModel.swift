//
//  recipesModel.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 15.08.23.
//

struct Recipe: Identifiable, Decodable {
    let id: Int
    let category: String
    let label: String
    let image: String
    let name: String
    let description: String
    let date: String
    let ingredients: String
    let instruction: String
}
