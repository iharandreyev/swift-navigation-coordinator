//
//  DeeplinkParser.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import Foundation

struct DeeplinksParser {
  func parse(url: URL) throws -> Deeplink {
    guard url.scheme == Deeplink.scheme else {
      throw DeeplinkParsingError.invalidScheme(url.scheme)
    }
    
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      throw DeeplinkParsingError.invalidURL(url)
    }
    
    guard let deeplink = components.host.compactMap(Deeplink.init(rawValue:)) else {
      throw DeeplinkParsingError.invalidAction(components.host)
    }

//    guard let recipeName = components.queryItems?.first(where: { $0.name == "name" })?.value else {
//        print("Recipe name not found")
//        return
//    }
    
    return deeplink
  }
}

enum DeeplinkParsingError: Error {
  case invalidScheme(String?)
  case invalidURL(URL)
  case invalidAction(String?)
}
