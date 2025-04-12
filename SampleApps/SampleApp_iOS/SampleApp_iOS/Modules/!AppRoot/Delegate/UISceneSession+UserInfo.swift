//
//  UISceneSession+UserInfo.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import UIKit

extension UISceneSession {
  func setInfoValue(
    _ value: Any,
    for key: SceneSessionInfoKey
  ) {
    var userInfo = self.userInfo ?? [:]
    userInfo[key.rawValue] = value
    self.userInfo = userInfo
  }
  
  func extractInfoValue<T>(
    forKey key: SceneSessionInfoKey
  ) -> T? {
    guard let rawValue = userInfo?[key.rawValue] else {
      logWarning("`\(self)` does not contain info for key `\(key)`")
      return nil
    }
    
    guard let value = rawValue as? T else {
      logWarning("`\(rawValue)` is not of type `\(T.self)`")
      return nil
    }
    
    userInfo?.removeValue(forKey: key.rawValue)
    
    return value
  }
}
