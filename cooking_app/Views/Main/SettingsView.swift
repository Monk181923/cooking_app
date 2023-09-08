//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI
import PhotosUI
import Alamofire

struct SettingsView: View {
    
    @State var logout: Bool = false
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var base64String: String?
    
    @State private var isChangingEmail = false
    @State private var isChangingUsername = false
    @State private var isChangingPassword = false
    @State private var email = ""
    @State private var username = ""
       
    
    @Environment(\.presentationMode) var presentationMode
    
    var URL_ADD_PICTURE = "http://cookbuddy.marcelruhstorfer.de/addPicture.php"
    
    var body: some View {
        
        NavigationView {
            List {
                Section(header: Text("Benutzerdaten")) {
                    EditableText(title: "Benutzername", text: $username, isEditing: $isChangingUsername)
                    EditableText(title: "E-Mail", text: $email, isEditing: $isChangingEmail)
                    Button(action: {
                        UserDefaults.standard.set("", forKey: "user_name")
                        UserDefaults.standard.set("", forKey: "user_email")
                        UserDefaults.standard.set("", forKey: "password")
                        UserDefaults.standard.set(nil, forKey: "picture")
                        UserDefaults.standard.set(nil, forKey: "likedRecipes")
                        UserDefaults.standard.synchronize()
                        logout = true
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                    .background(
                        NavigationLink("", destination: LoginView(), isActive: $logout)
                            .opacity(0)
                    )
                }
                
                Section(header: Text("Passwort")) {
                    Button(action: {
                        isChangingPassword.toggle()
                    }) {
                        Text("Passwort ändern")
                    }
                }
                
                Section(header: Text("App-Infos")) {
                    HStack {
                        Text("App-Version:")
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Einstellungen")
        }
        .onAppear {
            self.username = UserDefaults.standard.string(forKey: "user_name") ?? "Unbekannter Benutzer"
            self.email = UserDefaults.standard.string(forKey: "user_email") ?? "Unbekannte Mail"
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct EditableText: View {
    var title: String
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isEditing {
                TextField(title, text: $text)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(text)
            }
            Button(action: {
                isEditing.toggle()
            }) {
                Image(systemName: isEditing ? "checkmark.circle" : "pencil.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}
