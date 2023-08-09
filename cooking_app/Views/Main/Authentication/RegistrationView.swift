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
                        email=""
                        firstName=""
                        password=""
                        confirmPassword=""
                        confirmRegistration = true
                    }
                }
            }
            
        } else {
            confirmRegistration = false
        }
    }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
