//
//  SettingView.swift
//  RemoverWaterMark (iOS)
//
//  Created by sofent on 2022/4/28.
//

import SwiftUI

struct SettingView: View {
    @Binding var saveToPhotos: Bool
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Section("Setting"){
                    Divider()
                    Toggle("AutoSave", isOn:$saveToPhotos)
                    Divider()
                }
                .padding(.top,75)
                Spacer()
                
            }
            
            Divider().padding(.top,75)
        } .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        //.background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
    }
}
