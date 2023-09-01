//
//  RegistrationView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 28.06.23.
//

import SwiftUI
import Alamofire
import Foundation

struct RegistrationView: View {
    
    let URL_USER_REGISTER = "http://cookbuddy.marcelruhstorfer.de/register.php"
    let URL_USER_LOGIN = "http://cookbuddy.marcelruhstorfer.de/login.php"
    let defaultValues = UserDefaults.standard
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var confirmRegistration: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        
        NavigationStack {
            
            VStack (spacing: 15) {
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack (spacing: 86) {
                    VStack (spacing: 15) {
                        
                        TextField("E-Mail",
                                  text: $email,
                                  prompt: Text("E-Mail")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 17)))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal, 25)
                        
                        TextField("Vorname",
                                  text: $firstName,
                                  prompt: Text("Vorname")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 17)))
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal, 25)
                        
                        SecureField("Passwort",
                                  text: $password,
                                  prompt: Text("Passwort")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 17)))
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal, 25)
                        
                        SecureField("Passwort bestätigen",
                                  text: $confirmPassword,
                                  prompt: Text("Passwort bestätigen")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 17)))
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal, 25)
                    }
                    
                    Button {
                        checkSignUp()
                    } label: {
                        Text("Registrieren")
                            .font(.custom("Ubuntu-Bold", size: 17))
                            .foregroundColor(Color(hex: 0xFFFFFF))
                            .frame(maxWidth: .infinity, maxHeight: 54)
                    }
                    .background(Color(hex: 0x007C38))
                    .navigationDestination(
                         isPresented: $confirmRegistration) {
                             TabBarView()
                             Text("")
                                  .hidden()
                         }
                    .cornerRadius(14)
                    .shadow(radius: 4, x: 0, y: 5)
                    .padding(.horizontal, 25)
                }
                
                NavigationLink (destination: LoginView()) {
                    Text("Ich habe bereits einen Account!")
                        .font(.custom("Ubuntu", size: 14))
                        .foregroundColor(Color(hex: 0x757575))
                        .underline()
                }
            
                Spacer()
                
            }
            .background(Color(hex: 0xF2F2F7))
            .ignoresSafeArea()
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
        
    func checkSignUp() {
        if ((password == confirmPassword) && (password != "")) {
            let _parameters: Parameters=[
                "user_email":email,
                "user_name":firstName,
                "password":password,
            ]
            
            Alamofire.request(URL_USER_REGISTER, method: .post, parameters: _parameters).responseJSON{
                response in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    if ((jsonData.value(forKey: "message") as! String) == "User created successfully")
                    {
                        checkLogin()
                    }
                }
            }
            
        } else {
            confirmRegistration = false
        }
    }
    
    func checkLogin() {
        if ((email != "") && (password != "")) {
            let _parameters: Parameters=[
                "user_email":email,
                "password":password ]
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: _parameters).responseJSON {
                response in
                
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    //if there is no error
                    if(!(jsonData.value(forKey: "error") as! Bool)){
                        
                        //getting the user from response
                        let user = jsonData.value(forKey: "user") as! NSDictionary
                        
                        //getting user values
                        let userName = user.value(forKey: "user_name") as! String
                        let userEmail = user.value(forKey: "user_email") as! String
                        let id = user.value(forKey: "id") as! Int
                        let picture = user.value(forKey: "picture") as? String
                        
                        //saving user values to defaults
                        UserDefaults.standard.set(userName, forKey: "user_name")
                        UserDefaults.standard.set(userEmail, forKey: "user_email")
                        UserDefaults.standard.set(password, forKey: "password")
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(picture, forKey: "picture")
                        
                        let _parameters2: Parameters=[
                            "user_id":UserDefaults.standard.string(forKey: "id")!
                        ]
                        
                        Alamofire.request("http://cookbuddy.marcelruhstorfer.de/getRecipesId.php", method: .post, parameters: _parameters2).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if let json = value as? [String: Any], let recipesArray = json["recipes"] as? [[String: Any]] {
                                    let recipeIDs = recipesArray.compactMap { $0["recipe_id"] as? Int }
                                    UserDefaults.standard.set(recipeIDs, forKey: "likedRecipes")
                                }
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                            }
                        }
                        
                        UserDefaults.standard.synchronize()
                        
                        //switching the screen
                        email=""
                        firstName=""
                        password=""
                        confirmPassword=""
                        confirmRegistration = true
                        
                    }
                }
            }
        }
    }
    
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
