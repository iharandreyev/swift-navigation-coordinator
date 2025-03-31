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
    // TODO: Handle deeplinks here
  }
}
