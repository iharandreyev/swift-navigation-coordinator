//
//  SceneDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import UIKit

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
  
  private(set) weak var application: UIApplication?
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    if let uiApplicationRef: WeakRef<UIApplication> = session.extractInfoValue(forKey: .uiApplication) {
      application = uiApplicationRef.object
    }
  }
  
  func scene(
    _ scene: UIScene,
    openURLContexts urlContexts: Set<UIOpenURLContext>
  ) {
    guard !urlContexts.isEmpty else { return }
    
    guard let application else {
      logWarning("`\(Self.self).application` is missing. Deeplinks are disabled")
      return
    }
    
    let url = urlContexts.first!.url
    
    guard case .some = application.delegate?.application?(application, open: url, options: [:]) else {
      logWarning("`\(Self.self).application` is missing infrastructure to open `\(url)`. Ignoring")
      return
    }
  }
}
