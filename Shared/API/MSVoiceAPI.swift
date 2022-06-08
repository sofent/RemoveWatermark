//
//  MSVoiceAPI.swift
//  RemoverWaterMark (iOS)
//
//  Created by sofent on 2022/6/8.
//

import Foundation

let APPKEY=""

func issueToken() async ->String {
    let accessToken = UserDefaults.standard.string(forKey: "msvoice_token") ?? ""
    let date = (UserDefaults.standard.object(forKey: "msvoice_exprite_date") as? Date) ?? .now
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
