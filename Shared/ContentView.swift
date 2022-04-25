//
//  ContentView.swift
//  Shared
//
//  Created by sofent on 2022/4/24.
//

import SwiftUI

struct ContentView: View {
    @State var showImagePicker: Bool = false
    @State var showRecaptcha: Bool = false
    @State var url: String = ""
    @State var image: UIImage?
    var body: some View {
        VStack{
            if image != nil {
                HStack{
                    Image(uiImage: image!).resizable().aspectRatio(contentMode: .fit)
                    if url.count>0{
                        AsyncImageWithPlaceholder( url: url)
                    }
                }}
            Button (action:{
                
                self.showImagePicker.toggle()
            },label: {
                Text("Pick Image").padding()
            })
            .overlay(RoundedRectangle(cornerRadius: 1).stroke(.orange,lineWidth: 1))
        }
        .sheet(isPresented: $showRecaptcha){
            ReCaptchaView(){(str:String)->Void in
                print(str)
                self.showRecaptcha.toggle()
                uploadImage(token:str,paramName: "file", fileName: "test.png", image: self.image!){str  in
                    self.url=str
                    print(self.url)
                    if let data = try? Data(contentsOf: URL(string:str)!)
                    {
                        let imageToSave: UIImage! = UIImage(data: data)
                        let imageSaver=ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: imageToSave)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image
                self.showRecaptcha.toggle()
            }
        }}
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
