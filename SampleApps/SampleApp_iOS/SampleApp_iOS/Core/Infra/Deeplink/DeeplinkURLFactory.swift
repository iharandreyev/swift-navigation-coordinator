//
//  DeeplinkURLFactory.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import Foundation

enum DeeplinkURLFactory {
  static func createURL(for deeplink: Deeplink) -> URL {
    // open-recipe?name=Opened%20from%20inside%20the%20app
    return URL(string: "\(Deeplink.scheme)://\(deeplink.rawValue)")!
  }
}
