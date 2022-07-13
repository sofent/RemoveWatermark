//
//  ApiProtolcol.swift
//  RemoverWaterMark (iOS)
//
//  Created by 衡阵 on 2022/6/3.
//

import Foundation
import UIKit
import SwiftUI
import Combine

protocol ApiRequest {
    var model :CounterViewModel? { get set }
    func recaptchaCallback(token:String)
    func doRequest(image: UIImage) async -> UIImage?
}

class BaiduApiRequest:ApiRequest{
    
    var model: CounterViewModel?
    
    
    func recaptchaCallback(token:String){}
    
    
    func doRequest(image: UIImage) async -> UIImage? {
        let token = await getAccessToken()
        return await withCheckedContinuation { con in
            getResponseText(image, token: token){ image in
                con.resume(returning: image)
            }
        }
       
    }
    
}

class RemoveWatermarkApiRequest:ApiRequest{
    var tokenPass  = PassthroughSubject<String,Never>()
    var model :CounterViewModel?
    
    func recaptchaCallback(token:String){
        tokenPass.send(token)
    }
    
    func getToken() async -> String {
        DispatchQueue.main.async {
            self.model?.showRecaptcha = true
        }
        let token = await tokenPass.values.first{ e in
             return true
        }
        return token!
    }
    
    func doRequest(image: UIImage) async -> UIImage? {
        let token = await getToken()
        let str = await uploadImage(token:token,paramName: "file", fileName: "test.png", image: image)
        do{
            let (data,response) = try await URLSession.shared.data(from:  URL(string:str)!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            {
                let imageToSave: UIImage! = UIImage(data: data)
                print("get image ",imageToSave)
                return imageToSave
            }else{
                return nil
            }
        }catch{
            print(error)
        }
        return nil
       
    }
    
}
