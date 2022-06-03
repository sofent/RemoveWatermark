//
//  ContentViewModel.swift
//  RemoverWaterMark
//
//  Created by sofent on 2022/4/27.
//

import Foundation
#if !os(macOS)
import UIKit
#endif
import SwiftUI

final class CounterViewModel: ObservableObject {
    @Published var image :UIImage?
    @Published var imageMark: UIImage?
    @Published var showRecaptcha: Bool = false
    @Published var showProcessing: Bool = false
    @Published var showToast: Bool = false
    @AppStorage("autoSave") var saveToPhotos:Bool=false
    var api :ApiRequest
    init(api:ApiRequest){
        self.api = api
        self.api.model = self
    }
    
    func startProcess(image:UIImage?){
        self.image = image
        self.imageMark = nil
        self.showProcessing = true
        Task.init{
            print("api call begin")
            let result = await  api.doRequest(image: image!)
            print("api call end",result)
            DispatchQueue.main.async {
                self.showProcessing = false
                self.imageMark = result ?? UIImage(systemName: "exclamationmark.icloud")
                if self.saveToPhotos{
                    self.saveImage()
                }
            }
        }
    }
    
    func saveImage(){
        let imageSaver=ImageSaver()
        imageSaver.writeToPhotoAlbum(image: self.imageMark!)
        self.showToast=true
    }
   
}
