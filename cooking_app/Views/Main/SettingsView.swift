//
//  SettingsView.swift
//  cooking_app
//
//  Created by vislab-rechner-1212700 on 12.06.23.
//
//

import SwiftUI
import PhotosUI
import Alamofire

struct SettingsView: View {
    
    @State var logout: Bool = false
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var base64String: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    var URL_ADD_PICTURE = "http://cookbuddy.marcelruhstorfer.de/addPicture.php"
    
    var body: some View {
        
        NavigationView {
            
            VStack (spacing: 20) {
                
                Button {
                    UserDefaults.standard.set("", forKey: "user_name")
                    UserDefaults.standard.set("", forKey: "user_email")
                    UserDefaults.standard.set("", forKey: "password")
                    UserDefaults.standard.set(nil, forKey: "picture")
                    UserDefaults.standard.synchronize()
                    logout = true
                    
                } label: {
                    Text("Logout")
                        .font(.custom("Ubuntu-Bold", size: 17))
                        .navigationDestination(
                            isPresented: $logout) {
                                StartView()
                                Text("123")
                                    .hidden()
                            }
                }
                
                VStack {
                    
                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                    
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .padding(.horizontal, 25)
                    }
                }
                .onChange(of: avatarItem) { _ in
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                avatarImage = Image(uiImage: uiImage)
                                return
                            }
                        }
                    }
                }
                
                Button {
                    
                    let image = avatarImage
                    let size = CGSize(width: 100, height: 100)
                    
                    let uiImage = image!.getUIImage(newSize: size)
                    let imageData = uiImage!.pngData()
                    base64String = imageData!.base64EncodedString()
                    
                    UserDefaults.standard.set(base64String, forKey: "picture")
                    
                    addPicture()
                } label: {
                    Text("Upload")
                }
                
            }//Ende VStack
        }//Ende NavView
    }
    
    private func addPicture() {
        
        let _parameters: Parameters=[
            "id":UserDefaults.standard.string(forKey: "id")!,
            "picture": base64String!
        ]
        
        Alamofire.request(URL_ADD_PICTURE, method: .post, parameters: _parameters).responseJSON{
            response in
            print(response)
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                if ((jsonData.value(forKey: "message") as! String) == "Profile Picture added successfully")
                {
                    avatarImage = nil
                    avatarItem = nil
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
