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
    @State var showingSheet: Bool = false
    
    @State var url: String = ""
    @State var image: UIImage?
    @State var imageMark: UIImage?
    var body: some View {
        VStack{
            if image != nil {
                HStack{
                    Image(uiImage: image!).resizable().aspectRatio(contentMode: .fit)
                    if imageMark != nil {
                        Image(uiImage: imageMark!).resizable().aspectRatio(contentMode: .fit)
                    }
                }}
            HStack{
            Button (action:{
                
                self.showImagePicker.toggle()
            },label: {
                Text("Pick Image").padding()
            })
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(.orange,lineWidth: 1))
                if imageMark != nil {
                    Button (action:{
                        shareSheet(items: [imageMark!])
                    },label: {
                        Text("Share").padding()
                    }).overlay(RoundedRectangle(cornerRadius: 3).stroke(.orange,lineWidth: 1))
                }
            }
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
                        self.imageMark=imageToSave
                        let imageSaver=ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: imageToSave)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image

                        // set up activity view controller
                self.showRecaptcha.toggle()
            }
        }
        .sheet(isPresented: $showingSheet,
                       content: {
            ActivityView(activityItems: [self.image!] as [Any], applicationActivities: nil) })
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
