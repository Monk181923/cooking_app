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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    
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
                            .font(.custom("Ubuntu-Regular",fixedSize: 20)))
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal)
                        
                        TextField("Vorname",
                                  text: $firstName,
                                  prompt: Text("Vorname")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 20)))
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal)
                        
                        TextField("Passwort",
                                  text: $password,
                                  prompt: Text("Passwort")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 20)))
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal)
                        
                        TextField("Passwort bestätigen",
                                  text: $confirmPassword,
                                  prompt: Text("Passwort bestätigen")
                            .foregroundColor(Color(hex: 0x9C9C9C))
                            .font(.custom("Ubuntu-Regular",fixedSize: 20)))
                        .frame(maxHeight: 38)
                        .padding(10)
                        .background(Color(hex: 0xFAFAFA))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                        }
                        .padding(.horizontal)
                    }
                    
                    Button {
                        if ((password == confirmPassword) && (password != "")) {
                            let _parameters: Parameters=[
                                "user_email":email,
                                "user_name":firstName,
                                "password":password,
                            ]
                            
                            Alamofire.request(URL_USER_REGISTER, method: .post, parameters: _parameters).responseJSON {
                                response in
                                print(response)
                                
                                if let result = response.result.value {
                                    let jsonData = result as! NSDictionary
                                    
                                    if ((jsonData.value(forKey: "message") as! String) == "User created successfully")
                                    {
                                        print("User wurde erfolgreich registriert!")
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                        } else{
                            print("Beide Passwörter müssen gleich sein!")
                        }
                        
                    } label: {
                        Text("Registrieren")
                            .font(.custom("Ubuntu-Bold", size: 20))
                            .foregroundColor(Color(hex: 0xFFFFFF))
                            .frame(maxWidth: .infinity, maxHeight: 54)
                    }
                    .background(Color(hex: 0x007C38))
                    .cornerRadius(14)
                    .shadow(radius: 4, x: 0, y: 5)
                    .padding(.horizontal)
                }
                
                NavigationLink (destination: LoginView()) {
                    Text("Ich habe bereits einen Account!")
                        .font(.custom("Ubuntu", size: 16))
                        .foregroundColor(Color(hex: 0x757575))
                        .underline()
                }
            
                Spacer()
                
            }
            .background(Color(hex: 0xF2F2F7))
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
