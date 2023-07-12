//
//  LoginView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 28.06.23.
// hallo :D

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        NavigationStack {
            VStack {
                // image
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // form fields
                VStack(spacing: 24) {
                    InputView(text:$email,
                              title: "Email Adresse",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Text("Passwort vergessen?")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                        .font(.system(size:14))
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                Button {
                    print("log user in..")
                } label: {
                    HStack {
                        Text("Anmelden")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGreen))
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Ich habe noch keinen Account?")
                            .foregroundColor(.gray)
                        Text("Registrieren")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                    .font(.system(size:14))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
