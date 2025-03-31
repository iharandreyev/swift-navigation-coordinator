//
//  Deeplink.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator

enum Deeplink: String, DeeplinkEventType {
  static let scheme = "navc"
  
  case showUsecases
//  case showUsecasesAndShowModal
//  case showUsecasesPushAndShowModal
}

extension Deeplink: CaseIterable { }
