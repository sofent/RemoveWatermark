//
//  AIPersonView.swift
//  RemoverWaterMark (iOS)
//
//  Created by 衡阵 on 2022/6/3.
//

import SwiftUI

struct AIPersonView: View {
    @State var showImagePicker: Bool = false
    @State var image :UIImage?
    @State var personImage :UIImage?
   
    
    var body: some View {
        VStack{
            if image != nil {
                Image(uiImage: image!).resizable().aspectRatio(contentMode: .fit)
            }
            if personImage != nil {
                Image(uiImage: personImage!).resizable().aspectRatio(contentMode: .fit)
            }
            Spacer()
            Divider()
            HStack{
                Button("Pick Image"){
                    self.showImagePicker.toggle()
                }.buttonStyle(.borderedProminent)
            }
            Divider()
            
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.process(image)
            }
        }
    }
    
    func process(_ image:UIImage){
        self.image = image
        Task.init {
            let token = await getAccessToken()
            getResponseText(image,token: token){ forgroundImage in
                self.personImage = forgroundImage
            }
        }
        
    }
}

struct AIPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AIPersonView()
    }
}
