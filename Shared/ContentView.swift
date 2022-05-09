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
    @State var showToast: Bool = false
    
    @State var url: String = ""
    @ObservedObject var model = CounterViewModel()
    @State var imageMark: UIImage?
    var body: some View {
        
        SideSlideView(
            title:"Remove Watermark",
            side:{
                SettingView(saveToPhotos: $model.saveToPhotos)
            },
            content:{
                VStack{
                    
                    VStack{
                        if model.image != nil {
                            if (model.image?.size.height)! < (model.image?.size.width)!{
                                VStack{
                                    Image(uiImage: model.image!).resizable().aspectRatio(contentMode: .fit)
                                    if imageMark != nil {
                                        Image(uiImage: imageMark!).resizable().aspectRatio(contentMode: .fit)
                                            .contextMenu{
                                                Button("Share") {
                                                    self.showingSheet.toggle()
                                                }
                                                Button("Save") {
                                                    saveImage()
                                                }
                                            } .transition(.scale)
                                    }else{
                                        HStack{
                                            Spacer()
                                            ProgressView().padding()
                                            Spacer()
                                        }
                                        
                                    }
                                }
                            }else{
                                HStack{
                                    Image(uiImage: model.image!).resizable().aspectRatio(contentMode: .fit)
                                    if imageMark != nil {
                                        Image(uiImage: imageMark!).resizable().aspectRatio(contentMode: .fit)
                                            .contextMenu{
                                                Button("Share") {
                                                    self.showingSheet.toggle()
                                                }
                                                Button("Save") {
                                                    saveImage()
                                                }
                                            }
                                    }else{
                                        VStack{
                                            Spacer()
                                            ProgressView().padding()
                                            Spacer()
                                        }
                                    }
                                }}
                        }
                        
                        Spacer()
                        Divider()
                        HStack{
                            Button("Pick Image"){
                                self.showImagePicker.toggle()
                            }.buttonStyle(.borderedProminent)
                            if imageMark != nil {
                                Button ("Share"){
                                    shareSheet(items: [imageMark!])
                                }.buttonStyle(.borderedProminent)
                            }
                        }
                        Divider()
                    }
                    .sheet(isPresented: $model.showRecaptcha){
                        ReCaptchaView(){str in
                            print(str)
                            DispatchQueue.main.async {
                                self.model.showRecaptcha.toggle()
                            }
                            
                            uploadImage(token:str,paramName: "file", fileName: "test.png", image: self.model.image!){str  in
                                self.url=str
                                print(self.url)
                                
                                if let data = try? Data(contentsOf: URL(string:str)!)
                                {
                                    let imageToSave: UIImage! = UIImage(data: data)
                                    DispatchQueue.main.async {
                                        self.imageMark=imageToSave
                                        self.model.showProcessing=false
                                        if model.saveToPhotos{
                                            
                                            
                                            
                                            saveImage()
                                            
                                        }
                                    }
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.imageMark=UIImage(systemName: "prohibit")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(sourceType: .photoLibrary) { image in
                            startProcess(image: image)
                        }
                    }
                    .sheet(isPresented: $showingSheet,
                           content: {
                        ActivityView(activityItems: [self.model.image!] as [Any], applicationActivities: nil) })
                    .toast(message: "Image saved to gallery", isShowing: $showToast, duration: Toast.short)
                }
            }
        )
        
        
    }
    
    private func saveImage(){
        let imageSaver=ImageSaver()
        imageSaver.writeToPhotoAlbum(image: self.imageMark!)
        self.showToast.toggle()
    }
    
    func startProcess(image:UIImage?){
        self.model.image = image
        self.imageMark = nil
        self.model.showRecaptcha.toggle()
        self.model.showProcessing.toggle()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
