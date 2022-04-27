//
//  ContentViewModel.swift
//  RemoverWaterMark
//
//  Created by sofent on 2022/4/27.
//

import Foundation
#if !os(macOS)
import UIKit
#endif
import SwiftUI

final class CounterViewModel: ObservableObject {
    @Published var image :UIImage?
    @Published var showRecaptcha: Bool = false
    @Published var showProcessing: Bool = false
    @AppStorage("autoSave") var saveToPhotos:Bool=false
}
