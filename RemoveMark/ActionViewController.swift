//
//  ActionViewController.swift
//  RemoveMark
//
//  Created by sofent on 2022/4/26.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftUI

@objc(ActionViewController)
class ActionViewController: UIViewController {
    var imageURLStr:String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {

                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
                            DispatchQueue.global(qos: .userInitiated).async{
                            
                            if let imageURL = imageURL as? URL {
                                //3HG5533YQ5
                                let defaults = UserDefaults(suiteName: "group.or.sofent.RemoverWaterMark")
                                do{
                                    let imageData: Data = try Data(contentsOf: imageURL)
                                    defaults?.set(imageData, forKey: imageURL.absoluteString)
                                   
                                }catch{
                                        print("Unable to load data: \(error)")
                                }
                                self.imageURLStr = imageURL.absoluteString
                            }
                            
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
        if !imageFound {
            done()
        }
    }
    // For skip compile error.
    @objc func openURL(_ url: URL) {
        return
    }

    
    func openContainerApp(_ url:String,type:String) {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: "sremovemk://\(type)?"+url.urlEncoded!)!)
                return
            }
            responder = responder?.next
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let child = UIHostingController(rootView: ContentView{ str in
                self.openContainerApp(self.imageURLStr,type: str)
                self.done()
        })
        child.view.translatesAutoresizingMaskIntoConstraints = false
        let bounds = self.view.bounds
        child.view.frame = CGRect(origin: CGPoint(x: 0, y: bounds.height/3*2), size: CGSize(width: bounds.width, height: bounds.height/3))
        // First, add the view of the child to the view of the parent
        self.view.addSubview(child.view)
        // Then, add the child to the parent
        self.addChild(child)
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
    }

    func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}

struct ContentView : View {
    var done:(String)->Void
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "bookmark.slash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50,height: 50)
                    
                Text("RemoveWater")
            }
            .onTapGesture {
                done("rm")
            }
            Spacer()
            VStack {
                Image(systemName: "person.fill.questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50,height: 50)
                Text("AIPerson")
            }.onTapGesture {
                done("ai")
            }
            Spacer()
        }
    }
}

extension String {
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}
