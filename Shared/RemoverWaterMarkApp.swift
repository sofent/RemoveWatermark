//
//  RemoverWaterMarkApp.swift
//  Shared
//
//  Created by sofent on 2022/4/24.
//

import SwiftUI

@main
struct RemoverWaterMarkApp: App {
    var bodyView = ContentView()
    var body: some Scene {
        WindowGroup {
            bodyView
                .onOpenURL { url in
                    if url.scheme=="sremovemk" {
                        let imageUrl=url.host?.removingPercentEncoding
                        fetchImage(URL(string:imageUrl!))
                        
                    }
                    
                }
        }
    }
    
    private func fetchImage(_ photoURL: URL?) {

        guard let imageURL = photoURL else { return  }
       
        DispatchQueue.global(qos: .userInitiated).async {
            let defaults = UserDefaults(suiteName: "3HG5533YQ5.group.3HG5533YQ5.sofentapp")
            print(defaults!.synchronize())
            print(imageURL.absoluteString)
            print(defaults?.dictionaryRepresentation())
            let d = defaults!.string(forKey: "myfile")
            print(d as Any)
            do{
                let imageData: Data = try Data(contentsOf: imageURL)

                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.bodyView.image = image
                }
            }catch{
                    print("Unable to load data: \(error)")
            }
        }
    }
}
