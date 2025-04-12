//
//  Deeplink.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftNavigationCoordinator

enum Deeplink: String, DeeplinkEventType {
  static let scheme = "navc"
  
  case showUsecases = "show-usecases"
  case showUsecasesAndModalSheet = "show-usecases-and-modal-sheet"
  case showUsecasesAndModalCover = "show-usecases-and-modal-cover"
  case showUsecasesAndPushScreen = "show-usecases-and-push-screen"
  case showMultiChildPathA = "show-multi-child-path-a"
  case showMultiChildPathB = "show-multi-child-path-b"
}

extension Deeplink: CaseIterable { }
