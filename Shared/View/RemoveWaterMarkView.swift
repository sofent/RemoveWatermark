//
//  ContentView.swift
//  Shared
//
//  Created by sofent on 2022/4/24.
//

import SwiftUI

struct RemoveWatermarkView: View {
    @State var showImagePicker: Bool = false
    @State var showingSheet: Bool = false
    @EnvironmentObject var model :CounterViewModel
   
    
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
                        model.api.recaptchaCallback(token: str)
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
        .onOpenURL { url in
                switch url.scheme{
                case "sremovemk":
                    
                    let imageUrl=url.host?.removingPercentEncoding
                    fetchImage(imageUrl)
                case "file":
                    openURLImage(url)
                case .none:
                    print(url)
                case .some(_):
                    print(url)
                }
                
                
            }
    }
    
    private func openURLImage(_ photoURL: URL?) {
        
        let imageURL = photoURL
        
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: imageURL!)
                
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    model.startProcess(image: image)
                }
                
            }catch{
                print("Unable to load data: \(error)")
            }
        }}
    
    private func fetchImage(_ photoURL: String?) {
        
        guard let imageURL = photoURL else { return  }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let defaults = UserDefaults(suiteName: "group.or.sofent.RemoverWaterMark")
            defaults!.synchronize()
            let d = defaults!.data(forKey: imageURL)
            defaults?.removeObject(forKey: imageURL)
            let imageData: Data = d!
            
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                
                model.startProcess(image: image)
            }
            
        }
    }
}



struct RemoveWatermarkView_Previews: PreviewProvider {
    static var previews: some View {
        RemoveWatermarkView()
    }
}
