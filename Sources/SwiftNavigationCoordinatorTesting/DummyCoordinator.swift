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
  public typealias Destination = DummyDestination

  public var onProcessDeeplink: (any DeeplinkEventType) async -> ProcessDeeplinkResult
  
  public init(
    onProcessDeeplink: @escaping (any DeeplinkEventType) async -> ProcessDeeplinkResult,
    onFinish: Callback<Void>? = nil
  ) {
    self.onProcessDeeplink = onProcessDeeplink
    
    super.init(onFinish: onFinish)
  }
  
  public convenience init(
    processDeeplinkResult: ProcessDeeplinkResult = .impossible,
    onFinish: Callback<Void>? = nil
  ) {
    self.init(
      onProcessDeeplink: { _ in processDeeplinkResult },
      onFinish: onFinish
    )
  }
  
  public func initialScreen() -> DummyView {
    DummyView()
  }

  public func screenContent(
    for destination: Destination
  ) -> DummyView {
    DummyView()
  }
  
  public func screen(for destination: Destination) -> DummyView {
    DummyView()
  }
  
  public func label(
    for destination: Destination
  ) -> DummyLabel {
    DummyLabel()
  }
  
  public override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    await onProcessDeeplink(deeplink)
  }
}

public struct DummyDestination: DestinationType {
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
