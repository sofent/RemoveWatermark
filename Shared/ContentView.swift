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
    @State var showSetting: Bool = false
    
    @State var url: String = ""
    @ObservedObject var model = CounterViewModel()
    @State var imageMark: UIImage?
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.showSetting = false
                            }
                        }
                    }
       return  NavigationView{
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    VStack{
                        Divider()
                        if model.showProcessing {
                            ProgressView().padding()
                        }
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
                    
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showSetting ? geometry.size.width/2 : 0)
                    .background(Color(UIColor.systemBackground))
                    .onTapGesture {
                        withAnimation {
                        self.showSetting=false
                        }
                    }
                    if self.showSetting{
                        SettingView(saveToPhotos: $model.saveToPhotos)
                            .frame(width: geometry.size.width/2,height: geometry.size.height)
                                                        .transition(.move(edge: .leading))
                    }
                    
                }
                .simultaneousGesture(drag)
                //.gesture(drag)
                
            }.navigationBarTitleDisplayMode(.inline)
               .navigationTitle("Remove Water Mark")
               .navigationBarItems(leading: (
                   Button(action: {
                       withAnimation {
                           self.showSetting.toggle()
                       }
                   }) {
                       Image(systemName: "line.horizontal.3")
                           .imageScale(.large)
                   }
               ))
            
        }}
    
    private func saveImage(){
        let imageSaver=ImageSaver()
        imageSaver.writeToPhotoAlbum(image: self.imageMark!)
        self.showToast.toggle()
    }
    
    func startProcess(image:UIImage?){
        self.model.image = image
        
        self.model.showRecaptcha.toggle()
        self.model.showProcessing.toggle()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
