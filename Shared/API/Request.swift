//
//  Request.swift
//  RemoverWaterMark
//
//  Created by sofent on 2022/4/24.
//

import Foundation
import SwiftUI

func uploadImage(token:String,paramName: String, fileName: String, image: UIImage,callback: @escaping (String)->Void) {
    let url = URL(string: "https://api.pixelbin.io/service/panel/assets/v1.0/upload/direct")
    
    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString
    
    let session = URLSession.shared
    
    // Set the URLRequest to POST and to the specified URL
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"
    
    // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
    // And the boundary is also set here
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(token, forHTTPHeaderField: "captcha-code")
    urlRequest.setValue("MjAyMjA0MjRUMDc0NDQxWg==", forHTTPHeaderField: "x-ebg-param")
    urlRequest.setValue("v1:e72fb1133e4043381800aa5eb75bb5c61005320e9290825013cd6add1161e36d", forHTTPHeaderField: "x-ebg-signature")
    
    var data = Data()
    var tmpImg=image
    
    if image.size.height>2400 || image.size.width>2400 {
        tmpImg=image.resized(to: CGSize(width: 2000, height: 2000))
        
    }
    print(tmpImg.size)
    let imageData = tmpImg.jpegData(compressionQuality: 0.9)!
    print(imageData)
    data.addFilePart(boundary: boundary, name: paramName, filename: fileName, contentType: "image/jpeg", data: imageData)
    
    data.addParamPart(boundary: boundary, name: "filenameOverride", value: "true")
    data.addParamPart(boundary: boundary, name: "path", value: "__editor/2022-04-24")
    data.addMultiPartEnd(boundary: boundary)
    // Send a POST request to the URL, with the data we created earlier
    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            if let json = jsonData as? [String: Any] {
                print(json)
                let u=json["url"] as? String
                let nu=u?.replacingOccurrences(of: "original", with: "wm.remove()")
                callback(nu!)
            }else{
                callback("")
            }
        }else{
            callback("")
        }
    }).resume()
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}



private extension Data {
    mutating func addFilePart(boundary: String, name: String, filename: String, contentType: String, data: Data) {
        self.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        self.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        self.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        self.append(data)
    }
    
    mutating func addParamPart(boundary: String, name: String, value: String) {
        self.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        self.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        self.append(value.data(using: .utf8)!)
    }
    mutating func addMultiPartEnd(boundary: String) {
        self.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }}

func shareSheet(items: [Any]) {
    let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    let allScenes = UIApplication.shared.connectedScenes
    let scene = allScenes.first { $0.activationState == .foregroundActive }
    
    if let windowScene = scene as? UIWindowScene {
        windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
    }
    
}
