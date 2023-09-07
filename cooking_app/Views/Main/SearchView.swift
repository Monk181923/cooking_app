//
//  SearchView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 19.06.23.
//

import SwiftUI
import Alamofire
import PhotosUI

struct SearchView: View {

    var body: some View {
        NavigationView {
            VStack {
                Text("1")
            }
            .padding(.bottom, 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .edgesIgnoringSafeArea(.all)
            .background(Color.red)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
