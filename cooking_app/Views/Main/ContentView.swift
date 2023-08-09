//
//  ContentView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
// :D

import SwiftUI

struct ContentView: View {
    var body: some View {
//        ZStack {
//            Color.white
//                .ignoresSafeArea()
            
//        }
        //TabBarView()
        if (UserDefaults.standard.string(forKey: "password") == "") {
            StartView()
        } else {
            LoginView()
        }
    }
}

// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
