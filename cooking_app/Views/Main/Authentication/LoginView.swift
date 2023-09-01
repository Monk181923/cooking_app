//
//  StartView.swift
//  cooking_app
//
//  Created by Marcel Ruhstorfer on 18.07.23.
//

import SwiftUI
import Alamofire

struct LoginView: View {
    
    let URL_USER_LOGIN = "http://cookbuddy.marcelruhstorfer.de/login.php"
    let defaultValues = UserDefaults.standard
    
    @State var show = false
    @State var attempts: Int = 0
    @State var wrongPassword: Bool = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmLogin: Bool = false
    
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
                        .onAppear(perform: {
                            existensLogin()
                        })
                    
                    VStack (spacing: 62) {
                        VStack (spacing: 12){
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
                                
                                SecureField("Passwort",
                                          text: $password,
                                          prompt: Text("Passwort")
                                    .foregroundColor(Color(hex: 0x9C9C9C))
                                    .font(.custom("Ubuntu-Bold",fixedSize: 17)))
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .frame(maxHeight: 38)
                                .padding(10)
                                .background(Color(hex: 0xFAFAFA))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(wrongPassword ? Color(hex: 0xB91919) : Color(hex: 0xC5C5C5), lineWidth: 2)
                                }
                                .padding(.horizontal, 25)
                                .onChange(of: password) { newValue in
                                    if !newValue.isEmpty {
                                        wrongPassword = false
                                    }
                                }
                                .modifier(Shake(animatableData: CGFloat(attempts)))

                            }
                            
                            Button(action: {
                                withAnimation {
                                    self.show.toggle()
                                }
                                
                            }) {
                                Text("Passwort vergessen?")
                                    .font(.custom("Ubuntu",fixedSize: 14))
                                    .foregroundColor(Color(hex: 0x767676))
                                    .underline()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.horizontal, 25)
                            }
                        }
                        
                        VStack (spacing: 15) {
                            
                            Button {
                                checkLogin()
                            } label: {
                                Text("Anmelden")
                                    .font(.custom("Ubuntu-Bold", size: 17))
                                    .foregroundColor(Color(hex: 0xFFFFFF))
                                    .frame(maxWidth: .infinity, maxHeight: 54)
                                    .navigationDestination(
                                         isPresented: $confirmLogin) {
                                             TabBarView()
                                             Text("")
                                                  .hidden()
                                         }
                            }
                            .background(Color(hex: 0x007C38))
                            .cornerRadius(14)
                            .shadow(radius: 4, x: 0, y: 5)
                            .padding(.horizontal, 25)
                            
                            NavigationLink (destination: RegistrationView()) {
                                Text("Ich habe noch keinen Account!")
                                    .font(.custom("Ubuntu", size: 14))
                                    .foregroundColor(Color(hex: 0x757575))
                                    .underline()
                            }
                        }
                        Spacer()
                    }
                } // VStack Ende
                .background(Color(hex: 0xF2F2F7))
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
    
    public func existensLogin() {
        if (UserDefaults.standard.string(forKey: "password") != "")
        {
            self.email = UserDefaults.standard.string(forKey: "user_email") ?? ""
            print(email)
            self.password = UserDefaults.standard.string(forKey: "password") ?? ""
            print(password)
        }
        checkLogin()
        print("LOGIN gespeichert und getestet")
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
                        print(defaultValues)
                        confirmLogin = true
                        
                    } else {
                        //error message in case of invalid credential
                        print("Invalid username or password")
                        self.password = ""
                        self.wrongPassword = true
                        withAnimation(.default) {
                            self.attempts += 1
                        }
                    }
                }
            }
        }
    }
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
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
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

// Falsches Passwort schütteln

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
