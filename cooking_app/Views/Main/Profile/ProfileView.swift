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
                    Text(User.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(User.MOCK_USER.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(User.MOCK_USER.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                    }
                }
                
            }
            
            Section("Allgemein") {
                HStack {
                    SettingsRowView(imageName: "gear",
                                    title: "Version",
                                    tintColor: Color(.systemGray))
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
            }
            
            Section("Account") {
                Button {
                    print("Ausloggen..")
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill",              title: "Ausloggen",
                                    tintColor: .red)
                }
                
                Button {
                    print("Account löschen..")
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill",              title: "Account löschen",
                                    tintColor: .red)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
