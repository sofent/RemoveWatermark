//
//  ContentView.swift
//  RemoverWaterMark (iOS)
//
//  Created by 衡阵 on 2022/6/3.
//

import SwiftUI

struct ContentView: View {
    @State var activeTab = 0
    var removeWater = CounterViewModel(api: RemoveWatermarkApiRequest())
    var baidu = CounterViewModel(api: BaiduApiRequest())
    var url:URL?
    @State var showOptions  = false
    var body: some View {
        TabView(selection: $activeTab) {
            RemoveWatermarkView()
                .environmentObject(removeWater)
                .tabItem {
                    VStack {
                        Image(systemName: "bookmark.slash.fill")
                        Text("RemoveWater")
                    }
                }
                .tag(0)
            
            RemoveWatermarkView()
                .environmentObject(baidu)
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill.questionmark")
                        Text("AIPerson")
                    }
                }
                .tag(1)
            SettingView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
                }
                .tag(2)
        }
        .overlay{
            if showOptions{
            VStack{
                Text("Choose one to process:").font(.title3)
                Button("RemovewaterMark"){
                    showOptions = false
                    activeTab = 0
                    removeWater.openURLImage(url)
                }.buttonStyle(.bordered).padding()
                Button("BaiduAI"){
                    showOptions = false
                    activeTab = 1
                    baidu.openURLImage(url)
                }.buttonStyle(.bordered).padding()
            }.frame(maxWidth: .infinity, alignment: .center)
            .border(.regularMaterial, width: 3).background(Color.blue.opacity(0.3))
            }
        }
        .onOpenURL { url in
            switch url.scheme{
            case "sremovemk":
                let host = url.host!
                let imageUrl=url.query?.removingPercentEncoding
                switch host {
                case "rm":
                    activeTab = 0
                    removeWater.fetchImage(imageUrl)
                case "ai":
                    activeTab = 1
                    baidu.fetchImage(imageUrl)
                default:
                    print(url)
                }
                
            case "file":
               showOptions = true
            case .none:
                print(url)
            case .some(_):
                print(url)
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
