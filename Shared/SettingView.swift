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
                Divider() .padding(.top,75)
                Text("Setting")
               
                Divider()
                Toggle("AutoSave", isOn:$saveToPhotos)
                Spacer()
                
            }
            Spacer()
            Divider().padding(.top,75)
        } .padding()
            
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
    }
}
