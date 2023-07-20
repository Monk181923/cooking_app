//
//  LoginView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 28.06.23.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var show = false
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
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
                            
                            Button(action: {
                                withAnimation {
                                    self.show.toggle()
                                }
                                
                            }) {
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
                        
                        Spacer()
                    }
                    .background(Color(hex: 0xF2F2F7))
                } // VStack Ende
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                
                //GeometryReader für das einblenden der "Passwort vergessen" View
                if self.show {
                    GeometryReader{_ in
                        ZStack {
                            //Rechteck unter der View, zur Erkennung ob der Klick außerhalb der View war.
                            Rectangle()
                                .frame(width: .infinity, height: .infinity)
                                .opacity(0.001)
                                .layoutPriority(-1)
                                .onTapGesture {
                                    self.show.toggle()
                                }
                            
                            //Menu "Passwort vergessen" wird eingeblendet
                            Menu()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .background(Color.black.opacity(0.65))
                }
            } //ZStack Ende
        } // NavigationStack Ende
    } //Body Ende
} // View Ende

//Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//Passwort vergessen View
struct Menu : View {
    
    @State private var email = ""
    
    var body : some View {
        
        ZStack {
            
            VStack (spacing: 15) {
                
                Text("Passwort vergessen?")
                    .foregroundColor(Color.black)
                    .font(.custom("Ubuntu-Regular",fixedSize: 24))
                
                Text("Kein Problem, wir senden dir per E-Mail ein neues zu!")
                    .foregroundColor(Color.black)
                    .font(.custom("Ubuntu-Regular",fixedSize: 18))
                
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
                
                Button {
                    print("Button pressed")
                } label: {
                    Text("Neues Passwort senden")
                        .font(.custom("Ubuntu-Bold", size: 20))
                        .foregroundColor(Color(hex: 0xFFFFFF))
                        .frame(maxWidth: .infinity, maxHeight: 54)
                }
                .background(Color(hex: 0x007C38))
                .cornerRadius(14)
                .shadow(radius: 4, x: 0, y: 5)
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(Color(hex: 0xF2F2F7))
        .cornerRadius(10)
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: 0xC5C5C5), lineWidth: 4)
        }
        .padding()
    }
}
