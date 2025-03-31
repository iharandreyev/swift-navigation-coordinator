//
//  App.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import SwiftUI

@main
struct App: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self)
  private var appDelegate

  init() { }
  
  var body: some Scene {
    WindowGroup {
      Text("App Root")
    }
  }
}
