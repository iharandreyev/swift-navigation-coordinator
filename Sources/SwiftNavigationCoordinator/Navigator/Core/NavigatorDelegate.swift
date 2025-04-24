//
//  NavigatorDelegate.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
public protocol NavigatorDelegate: AnyObject {
  func navigatorDidDismissModalDestination(_ destination: AnyIdentifiableDestination)
  func navigatorDidDismissStackDestination(_ destination: AnyIdentifiableDestination)
}
