//
//  RegistrationView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 28.06.23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // image
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            VStack(spacing: 24) {
                InputView(text:$email,
                          title: "Email Adresse",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text:$fullName,
                          title: "Vorname",
                          placeholder: "Mustername")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                InputView(text: $confirmPassword,
                          title: "Password bestätigen",
                          placeholder: "Passwort bestätigen",
                          isSecureField: true)
                
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                print("Benutzer Registrieren..")
            } label: {
                HStack {
                    Text("Registrieren")
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
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Ich habe bereits einen Account?")
                        .foregroundColor(.gray)
                    Text("Anmelden")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .font(.system(size:14))
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
