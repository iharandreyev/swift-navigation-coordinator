//
//  URLOpener.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI
import UIKit

protocol URLOpener: Sendable {
  func openURL(_ url: URL)
}

private struct ThrowingURLOpener: URLOpener {
  func openURL(_ url: URL) {
    fatalError("URL Opener was never set")
  }
}

private struct URLOpenerKey: EnvironmentKey {
  static let defaultValue: URLOpener = ThrowingURLOpener()
}

extension EnvironmentValues {
  var urlOpener: URLOpener {
    get { self[URLOpenerKey.self] }
    set { self[URLOpenerKey.self] = newValue }
  }
}
