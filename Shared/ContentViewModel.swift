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
    
    func startProcess(image:UIImage?){
        self.image = image
        self.imageMark = nil
        self.showRecaptcha.toggle()
        self.showProcessing.toggle()
    }
    
    func saveImage(){
        let imageSaver=ImageSaver()
        imageSaver.writeToPhotoAlbum(image: self.imageMark!)
        self.showToast=true
    }
    func req2RemoveWatermark(token:String){
        uploadImage(token:token,paramName: "file", fileName: "test.png", image: self.image!){str  in
            
            if let data = try? Data(contentsOf: URL(string:str)!)
            {
                let imageToSave: UIImage! = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageMark=imageToSave
                    self.showProcessing=false
                    if self.saveToPhotos{
                        self.saveImage()
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
