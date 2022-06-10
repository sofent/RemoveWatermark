//
//  SettingView.swift
//  RemoverWaterMark (iOS)
//
//  Created by sofent on 2022/4/28.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("autoSave") var saveToPhotos:Bool=false
    var body: some View {
        VStack{
            Section("Save Settiing"){
                Toggle("AutoSave", isOn:$saveToPhotos)
                Spacer()
                
            }
            Spacer()
            Divider().padding(.top,75)
        } .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
    }
}
