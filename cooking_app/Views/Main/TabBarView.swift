//
//  TabBarView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedTab: Int = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(hex: 0xF2F2F7))
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    var body: some View {

        TabView () {
                HomeView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(0)
                
            /*
                SearchView()
                    .tabItem {
                        Label("Suche", systemImage: "magnifyingglass")
                    }
             */
                
                CreateRecipeView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Rezept", systemImage: "plus")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(1)
                
                FavoritesView()
                    .tabItem {
                        Label("Kochbuch", systemImage: "bookmark")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Label("Profil", systemImage: "person")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(3)
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
