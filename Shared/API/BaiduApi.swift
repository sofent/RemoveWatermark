//
//  BaiduApi.swift
//  RemoverWaterMark (iOS)
//
//  Created by 衡阵 on 2022/6/3.
//

import Foundation
import SwiftUI

let clientID = "M1hAGDsgNLXvVNlQXONHGvwI"
let clientSec = "eICwvgUcyKdUNGQNAXfCCOGDsHv2Urmq"


func getAccessToken() async ->String {
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToekn") ?? ""
    let date = (UserDefaults.standard.object(forKey: "exprite_date") as? Date) ?? .now
    if accessToken != "" && date.addingTimeInterval(-3600) > .now {
        return accessToken
    }
    
    let host = "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSec)"
    guard let url = URL(string: host) else { return ""}
    let session = URLSession.shared
    let req = URLRequest(url: url)
    do {
        let  (responseData, response) = try await session.data(for: req)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            return accessToken
        }
        let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
        if let json = jsonData as? [String: Any] {
            print(json)
            let token = json["access_token"] as? String ?? ""
            let expire_in = json["expires_in"] as? Int ?? 0
            UserDefaults.standard.set(token, forKey: "accessToekn")
            UserDefaults.standard.set(Date.now.addingTimeInterval(TimeInterval(expire_in)), forKey: "exprite_date")
            return token
        }
    }catch{
        print(error)
    }
    return accessToken
}

func getResponseText(_ image:UIImage,token :String)async -> UIImage? {
    let host = "https://aip.baidubce.com/rest/2.0/image-classify/v1/body_seg?access_token=\(token)"
    guard let url = URL(string: host) else {
       return nil
    }
    let session = URLSession.shared
    var req = URLRequest(url: url)
    req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    req.setValue("application/json", forHTTPHeaderField: "Accept")
    req.httpMethod = "POST"
    guard let baseData = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() else{
       return nil
    }
    print(baseData.count/1024)
    //print(baseData)
    var data = Data()
    data.append("image=".data(using: .utf8)!)
    data.append(baseData.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!.data(using: .utf8)!)
    print(data.prefix(50).base64EncodedString())
    req.httpBody = data
    do{
        let (responseData, response) = try await session.data(for: req)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200{
            return nil
        }
        let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
        if let json = jsonData as? [String: Any] {
            guard let forground = json["foreground"] as? String else {
                print(json)
               return nil
            }
            let forgroundImage = UIImage(data: Data(base64Encoded: forground) ?? Data())
            return forgroundImage
        }
    }catch{
        print(error)
    }
    return nil
}
