//
//  UIImage++.swift
//  RemoverWaterMark (iOS)
//
//  Created by sofent on 2022/6/17.
//

import Foundation
import UIKit

extension UIImage {
    public func resized(to target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio/UIScreen.main.scale, height: size.height * ratio/UIScreen.main.scale
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}
