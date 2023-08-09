//
//  ProfileView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 03.07.23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section {
                HStack {
                        
                    }
                }
                
            }
            
            Section("Allgemein") {
                HStack {
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
            }
        }
    }

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
