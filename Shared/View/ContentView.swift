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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
