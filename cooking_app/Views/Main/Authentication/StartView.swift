//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack (spacing: 120) {
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                VStack (spacing: 24) {
                    
                    NavigationLink(destination: RegistrationView()) {
                        
                        Text("Jetzt registrieren")
                            .font(.custom("Ubuntu-Bold", size: 20))
                            .foregroundColor(Color(hex: 0xFFFFFF))
                            .frame(maxWidth: .infinity, maxHeight: 54)
                    }
                    .background(Color(hex: 0x007C38))
                    .cornerRadius(14)
                    .shadow(radius: 4, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    NavigationLink (destination: LoginView()) {
                        
                        Text("Ich habe bereits einen Account")
                            .font(.custom("Ubuntu-Bold", size: 20))
                            .foregroundColor(Color(hex: 0x007C38))
                            .frame(maxWidth: .infinity, maxHeight: 54)
                    }
                    .background(Color(hex: 0xFAFAFA))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: 0xC5C5C5), lineWidth: 2)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .background(Color(hex: 0xF2F2F7))
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
