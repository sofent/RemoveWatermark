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
    }
    private func openURLImage(_ photoURL: URL?) {
        
        let imageURL = photoURL
        
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: imageURL!)
                
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    bodyView.startProcess(image: image)
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
                
                bodyView.startProcess(image: image)
            }
            
        }
    }
}
