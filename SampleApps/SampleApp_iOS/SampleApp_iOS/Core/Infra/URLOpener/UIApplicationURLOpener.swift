//
//  UIApplicationURLOpener.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import UIKit

struct UIApplicationURLOpener: URLOpener {
  func openURL(_ url: URL) {
    Task.detached { @MainActor in
      UIApplication.shared.open(url)
    }
  }
}
