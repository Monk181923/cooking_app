//
//  TabBarView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
            TabView {
                    HomeView()
                        .tabItem {
                            Label("Dashboard", systemImage: "house")
                        }
                    
                    SearchView()
                        .tabItem {
                            Label("Suche", systemImage: "magnifyingglass")
                        }
                    
                    NewRecipeView()
                        .tabItem {
                            Label("", systemImage: "plus")
                        }
                    
                    FavoritesView()
                        .tabItem {
                            Label("Kochbuch", systemImage: "bookmark")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Profil", systemImage: "person")
                        }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .ignoresSafeArea()
    } // Ende body
} // Ende TabBarView

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
