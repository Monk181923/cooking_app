//
//  LoginView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 28.06.23.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack (spacing: 42) {
                Spacer()
                
                // Logo Image
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack (spacing: 62) {
                    VStack (spacing: 12){
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
                            
                            TextField("Passwort",
                                      text: $email,
                                      prompt: Text("Passwort")
                                .foregroundColor(Color(hex: 0x9C9C9C))
                                .font(.custom("Ubuntu-Bold",fixedSize: 20)))
                            .frame(maxHeight: 38)
                            .padding(10)
                            .background(Color(hex: 0xFAFAFA))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                            }
                            .padding(.horizontal)
                        }
                        
                        NavigationLink (destination: SplashScreenView()) {
                            Text("Passwort vergessen?")
                                .font(.custom("Ubuntu",fixedSize: 16))
                                .foregroundColor(Color(hex: 0x767676))
                                .underline()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal)
                        }
                    }
                    
                    VStack (spacing: 15) {
                        
                        Button {
                            print("Button pressed")
                        } label: {
                            Text("Anmelden")
                                .font(.custom("Ubuntu-Bold", size: 20))
                                .foregroundColor(Color(hex: 0xFFFFFF))
                                .frame(maxWidth: .infinity, maxHeight: 54)
                        }
                        .background(Color(hex: 0x007C38))
                        .cornerRadius(14)
                        .shadow(radius: 4, x: 0, y: 5)
                        .padding(.horizontal)
                        
                        NavigationLink (destination: RegistrationView()) {
                            Text("Ich habe noch keinen Account!")
                                .font(.custom("Ubuntu", size: 16))
                                .foregroundColor(Color(hex: 0x757575))
                                .underline()
                        }
                    }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
