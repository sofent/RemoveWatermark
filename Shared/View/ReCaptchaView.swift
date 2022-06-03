//
//  ReCaptchaView.swift
//  RemoverWaterMark
//
//  Created by sofent on 2022/4/24.
//

import SwiftUI

public struct ReCaptchaView:UIViewControllerRepresentable{
    private let delegate :((String)->Void)?
    public init(del:((String)->Void)?){
        self.delegate=del
    }
    
    public func updateUIViewController(_ uiViewController: ReCAPTCHAViewController, context: Context) {
        
    }
    
    public func makeUIViewController(context: Context) -> ReCAPTCHAViewController {
        let viewModel = ReCAPTCHAViewModel(
            siteKey: "6LcgwSsdAAAAAJO_QsCkkQuSlkOal2jqXic2Zuvj",
            url: URL(string: "https://www.watermarkremover.io/upload")!
        )
        viewModel.delegate=self.delegate
        let c = ReCAPTCHAViewController(viewModel: viewModel)
        
        return c
    }
    
    public func makeCoordinator(){
        
    }
}






