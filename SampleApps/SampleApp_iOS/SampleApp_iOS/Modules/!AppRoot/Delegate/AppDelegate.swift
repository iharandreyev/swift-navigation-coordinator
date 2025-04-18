//
//  AppDelegate.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftNavigationCoordinator
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
  var onHandleDeeplink: ((Deeplink) -> Bool)?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    SwiftNavigationCoordinator.setLogger(Logger.shared)
    
    return true
  }
  
  func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    do {
      let deeplink = try DeeplinksParser().parse(url: url)
      guard let onHandleDeeplink else { return false }
      return onHandleDeeplink(deeplink)
    } catch {
      logWarning("Can't parse deeplink from \(url): \(error)")
      return false
    }
  }
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let sceneConfig: UISceneConfiguration = UISceneConfiguration(
      name: nil,
      sessionRole: connectingSceneSession.role
    )
    sceneConfig.delegateClass = SceneDelegate.self
    
    connectingSceneSession.setInfoValue(
      WeakRef<UIApplication>(object: application),
      for: .uiApplication
    )
    
    return sceneConfig
  }
}
