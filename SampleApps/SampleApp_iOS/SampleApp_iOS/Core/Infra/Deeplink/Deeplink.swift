//
//  Deeplink.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator

enum Deeplink: String, DeeplinkEventType {
  static let scheme = "navc"
  
  case switchTab
//  case switchTabAndShowModal
//  case switchTabPushAndShowModal
}

extension Deeplink: CaseIterable { }
