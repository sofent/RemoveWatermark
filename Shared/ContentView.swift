//
//  ContentView.swift
//  Shared
//
//  Created by sofent on 2022/4/24.
//

import SwiftUI

struct ContentView: View {
    @State var showImagePicker: Bool = false
    @State var showingSheet: Bool = false
    
    @State var url: String = ""
    @ObservedObject var model = CounterViewModel()
    @State var imageMark: UIImage?
    var body: some View {
        Section("AutoSave to Photos") {
            Toggle("AutoSave", isOn: $model.saveToPhotos)
        }
        Divider()
        VStack{
            if model.image != nil {
                if (model.image?.size.height)! < (model.image?.size.width)!{
                    VStack{
                        Image(uiImage: model.image!).resizable().aspectRatio(contentMode: .fit)
                        if imageMark != nil {
                            Image(uiImage: imageMark!).resizable().aspectRatio(contentMode: .fit)
                        }
                    }
                }else{
                    HStack{
                        Image(uiImage: model.image!).resizable().aspectRatio(contentMode: .fit)
                        if imageMark != nil {
                            Image(uiImage: imageMark!).resizable().aspectRatio(contentMode: .fit)
                        }
                    }}
                }
                
            Spacer()
            Divider()
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
        .sheet(isPresented: $model.showRecaptcha){
            ReCaptchaView(){str in
                print(str)
                self.model.showRecaptcha.toggle()
                uploadImage(token:str,paramName: "file", fileName: "test.png", image: self.model.image!){str  in
                    self.url=str
                    print(self.url)
                    
                    if let data = try? Data(contentsOf: URL(string:str)!)
                    {
                        let imageToSave: UIImage! = UIImage(data: data)
                        self.imageMark=imageToSave
                        if model.saveToPhotos{
                            let imageSaver=ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: imageToSave)
                        }}
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.model.image = image
                
                // set up activity view controller
                self.model.showRecaptcha.toggle()
            }
        }
        .sheet(isPresented: $showingSheet,
               content: {
            ActivityView(activityItems: [self.model.image!] as [Any], applicationActivities: nil) })
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
