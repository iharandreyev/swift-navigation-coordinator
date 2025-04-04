//
//  DummyCoordinator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

import SwiftUI
import SwiftNavigationCoordinator

/// A dummy coordinator meant to be plugged in as a dependency into a parent coordinator
///
/// Useful for testing coordinator behavior when we don't care about child coordinator type.
public final class DummyCoordinator:
  CoordinatorBase,
  ScreenCoordinatorType,
  ModalCoordinatorType,
  StackCoordinatorType,
  StaticSpecimenCoordinatorType,
  LabelledSpecimenCoordinatorType
{
  public typealias DestinationType = DummyDestination
  
  public let stackNavigator = StackNavigator<DestinationType>()
  public let modalNavigator = ModalNavigator<DestinationType>()
  public let specimenNavigator = SpecimenNavigator<DestinationType>(initialDestination: DestinationType())
  
  public var onProcessDeeplink: @Sendable (any DeeplinkEventType) async -> ProcessDeeplinkResult = { _ in
    .impossible
  }
  
  public func initialScreen() -> DummyView {
    DummyView()
  }

  public func screenContent(
    for destination: DestinationType
  ) -> DummyView {
    DummyView()
  }
  
  public func label(
    for destination: DestinationType
  ) -> DummyLabel {
    DummyLabel()
  }
  
  public override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    await onProcessDeeplink(deeplink)
  }
}

extension DummyCoordinator {
  public func with(
    onProcessDeeplink: @Sendable @escaping (
      any DeeplinkEventType
    ) async -> ProcessDeeplinkResult
  ) -> DummyCoordinator {
    self.onProcessDeeplink = onProcessDeeplink
    return self
  }
  
  public func with(
    processDeeplinkResult: ProcessDeeplinkResult
  ) -> DummyCoordinator {
    self.onProcessDeeplink = { _ in processDeeplinkResult }
    return self
  }
}

public struct DummyDestination: ModalDestinationContentType {
  public let id: String
  
  public init(id: String = "dummy-destination") {
    self.id = id
  }
}

extension DummyDestination: CaseIterable {
  static public var allCases: [DummyDestination] { [DummyDestination()] }
}

public struct DummyLabel: View {
  public init() { }
  
  public let body = EmptyView()
}

public struct DummyView: View {
  public init() { }
  
  public let body = EmptyView()
}
