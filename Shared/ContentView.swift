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
    
    @EnvironmentObject var model : CounterViewModel
    
    @ViewBuilder var imageView : some View{
        Image(uiImage: model.image!).resizable().aspectRatio(contentMode: .fit)
        if model.imageMark != nil {
            Image(uiImage: model.imageMark!).resizable().aspectRatio(contentMode: .fit)
                .contextMenu{
                    Button("Share") {
                        self.showingSheet.toggle()
                    }
                    Button("Save") {
                        model.saveImage()
                    }
                } .transition(.scale)
        }else{
            ProgressView().padding()
        }
    }
    var body: some View {
        
        SideSlideView(title:"Remove Watermark"){
            SettingView(saveToPhotos: $model.saveToPhotos)
        } content:{
            VStack{
                VStack{
                    if model.image != nil {
                        GeometryReader(){ geometry in
                            if ((model.image?.size.height)! / (model.image?.size.width)!) < geometry.size.height / geometry.size.width {
                                VStack(){
                                    imageView
                                }.frame(width: geometry.size.width, height: nil, alignment: .center)
                            }else{
                                HStack{
                                    imageView
                                }.frame(width: nil, height: geometry.size.height, alignment: .center)
                            }
                            
                        }
                    }
                    
                    Spacer()
                    Divider()
                    HStack{
                        Button("Pick Image"){
                            self.showImagePicker.toggle()
                        }.buttonStyle(.borderedProminent)
                        if model.imageMark != nil {
                            Button ("Share"){
                                shareSheet(items: [model.imageMark!])
                            }.buttonStyle(.borderedProminent)
                        }
                    }
                    Divider()
                }
                .sheet(isPresented: $model.showRecaptcha){
                    ReCaptchaView(){str in
                        DispatchQueue.main.async {
                            self.model.showRecaptcha.toggle()
                        }
                        model.req2RemoveWatermark(token: str)
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        model.startProcess(image: image)
                    }
                }
                .sheet(isPresented: $showingSheet,
                       content: {
                    ActivityView(activityItems: [self.model.image!] as [Any], applicationActivities: nil) })
                .toast(message: "Image saved to gallery", isShowing: $model.showToast, duration: Toast.short)
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CounterViewModel())
    }
}
