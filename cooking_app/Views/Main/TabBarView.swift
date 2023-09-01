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
                        .edgesIgnoringSafeArea(.top)
                    
                /*
                    SearchView()
                        .tabItem {
                            Label("Suche", systemImage: "magnifyingglass")
                        }
                 */
                    
                    CreateRecipeView()
                        .tabItem {
                            Label("Rezept", systemImage: "plus")
                        }
                        .edgesIgnoringSafeArea(.top)
                    
                    FavoritesView()
                        .tabItem {
                            Label("Kochbuch", systemImage: "bookmark")
                        }
                        .edgesIgnoringSafeArea(.top)
                    
                    SettingsView()
                        .tabItem {
                            Label("Profil", systemImage: "person")
                        }
                        .edgesIgnoringSafeArea(.top)
            }
            .accentColor(Color(hex: 0x007C38))
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    } // Ende body
} // Ende TabBarView

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
