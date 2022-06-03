//
//  SideSlideView.swift
//  RemoverWaterMark (iOS)
//
//  Created by sofent on 2022/5/9.
//

import SwiftUI

struct SideSlideView<Side,Content>: View where Side:View,Content:View {
    
    private var sideContent : () -> Side
    private var content : ()-> Content
    private let title : String
    
    @State private var showSetting = false
    
    public init(title:String,@ViewBuilder side:@escaping ()->Side,@ViewBuilder content:@escaping ()->Content){
        self.title=title
        self.sideContent=side
        self.content=content
    }
    
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.showSetting = false
                            }
                        }
                    }
        NavigationView{
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    content()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: self.showSetting ? geometry.size.width/2 : 0)
                        .background(Color(UIColor.systemBackground))
                        .onTapGesture {
                            withAnimation {
                            self.showSetting=false
                            }
                        }.blur(radius: self.showSetting ? 2 : 0)
                    if showSetting {
                        sideContent()
                            .frame(width: geometry.size.width/2,height: geometry.size.height)
                            .background(Color.secondary)
                                                        .transition(.move(edge: .leading))
                    }
                }.gesture(drag)
                
            }.navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showSetting.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
            
        }.navigationViewStyle(.stack)
    }
}

struct SideSlideView_Previews: PreviewProvider {
    static var previews: some View {
        SideSlideView(title:"Test",side: {
            Text("Hello")
        }, content: {
            Text("World")
        })
    }
}
