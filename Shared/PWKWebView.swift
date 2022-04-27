import Foundation
import SwiftUI
import WebKit


class PWKWebView:WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension WKWebView {
    
    enum PrefKey {
        static let cookie = "cookies"
    }
    
    func writeDiskCookies(for domain: String, completion: @escaping () -> ()) {
        fetchInMemoryCookies(for: domain) { data in
            print("write data", data)
            UserDefaults.standard.setValue(data, forKey: PrefKey.cookie + domain)
            completion();
        }
    }
    
    
    func loadDiskCookies(for domain: String, completion: @escaping () -> ()) {
        if let diskCookie = UserDefaults.standard.dictionary(forKey: (PrefKey.cookie + domain)){
            fetchInMemoryCookies(for: domain) { freshCookie in
                
                let mergedCookie = diskCookie.merging(freshCookie) { (_, new) in new }
                
                for (_, cookieConfig) in mergedCookie {
                    let cookie = cookieConfig as! Dictionary<String, Any>
                    
                    var expire : Any? = nil
                    
                    if let expireTime = cookie["Expires"] as? Double{
                        expire = Date(timeIntervalSinceNow: expireTime)
                    }
                    
                    let newCookie = HTTPCookie(properties: [
                        .domain: cookie["Domain"] as Any,
                        .path: cookie["Path"] as Any,
                        .name: cookie["Name"] as Any,
                        .value: cookie["Value"] as Any,
                        .secure: cookie["Secure"] as Any,
                        .expires: expire as Any
                    ])
                    
                    self.configuration.websiteDataStore.httpCookieStore.setCookie(newCookie!)
                }
                
                completion()
            }
            
        }
        else{
            completion()
        }
    }
    
    func fetchInMemoryCookies(for domain: String, completion: @escaping ([String: Any]) -> ()) {
        var cookieDict = [String: AnyObject]()
        
        self.configuration.websiteDataStore.httpCookieStore.getAllCookies{ cookies in
            for cookie in cookies {
                if cookie.domain.contains(domain) {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)}
        
    }}

//ATTENTION: ACTION REQUIRED (5/5): Put your remote website URL here
//
//This iOS WKWebView template app will browse your remote website fullscreen (with Status Bar visible)
//So, keep in mind that your remote website should look and feel like iOS app (as much as possible),
//especially if you are planning to distribute it via App Store and expect to successfully pass Apple's App Review
let url = URL(string: "https://www.google.com")!

extension ReCAPTCHAViewController: WKUIDelegate, WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //load cookie of current domain
        if let host=navigationAction.request.url?.host{
            print(host)
            webView.loadDiskCookies(for: host){
                decisionHandler(.allow)
            }
        }else{
            decisionHandler(.allow)
        }
       
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let res=navigationResponse.response as! HTTPURLResponse
        let cookie=HTTPCookie.cookies(withResponseHeaderFields: res.allHeaderFields as! [String:String], for: URL(string:(res.url?.host)!)!)
        print("cookie:",cookie)
        webView.writeDiskCookies(for: (navigationResponse.response.url?.host!)!){
            decisionHandler(.allow)
        }
    }
}
