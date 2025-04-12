//
//  AnyStackNavigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

@MainActor
final class AnyStackNavigator: StackStateDelegate {
  private let _state: () -> StackState
  private let _getParent: () -> AnyStackNavigator?
  private let _setParent: (AnyStackNavigator?) -> Void
  private let _getChild: () -> AnyStackNavigator?
  private let _setChild: (AnyStackNavigator?) -> Void
  private let _getStack: () -> [AnyDestination]
  private let _setStack: ([AnyDestination]) -> Void
  private let _performInvalidate: () -> Void
  private let _onUserDidChangeStack: (StackUserInteraction) -> Void
  
  fileprivate let id: ObjectIdentifier
  
  var state: StackState {
    _state()
  }
  
  var parent: AnyStackNavigator? {
    get { _getParent() }
    set { _setParent(newValue) }
  }
  
  var child: AnyStackNavigator? {
    get { _getChild() }
    set { _setChild(newValue) }
  }
  
  var stack: [AnyDestination] {
    get { _getStack() }
    set { _setStack(newValue) }
  }
  
  fileprivate init<Destination>(
    _ wrapped: StackNavigator<Destination>
  ) {
    _state = { [unowned wrapped] in wrapped.state }
    _getParent = { [unowned wrapped] in wrapped.getParent() }
    _setParent = { [unowned wrapped] in wrapped.setParent($0) }
    _getChild = { [unowned wrapped] in wrapped.getChild() }
    _setChild = { [unowned wrapped] in wrapped.setChild($0) }
    _getStack = { [unowned wrapped] in wrapped.getStack() }
    _setStack =  { [unowned wrapped] in wrapped.setStack($0) }
    _onUserDidChangeStack = { [unowned wrapped] in wrapped.userDidChangeStack(with: $0) }
    _performInvalidate = { [unowned wrapped] in wrapped.performInvalidate() }
    id = ObjectIdentifier(wrapped)
  }
  
  func invalidate() {
    _performInvalidate()
  }
  
  func userDidChangeStack(
    with interaction: StackUserInteraction
  ) {
    _onUserDidChangeStack(interaction)
  }
}

extension AnyStackNavigator: @preconcurrency Equatable {
  static func == (lhs: AnyStackNavigator, rhs: AnyStackNavigator) -> Bool {
    lhs.id == rhs.id
  }
  
  static func == <Destination>(lhs: AnyStackNavigator, rhs: StackNavigator<Destination>) -> Bool {
    lhs.id == ObjectIdentifier(rhs)
  }
  
  static func == <Destination>(lhs: StackNavigator<Destination>, rhs: AnyStackNavigator) -> Bool {
    ObjectIdentifier(lhs) == rhs.id
  }
}

extension Optional where Wrapped == AnyStackNavigator {
  static func == (lhs: Self, rhs: AnyStackNavigator) -> Bool {
    lhs.optional?.id == rhs.id
  }
  
  static func == (lhs: AnyStackNavigator, rhs: Self) -> Bool {
    lhs.id == rhs.optional?.id
  }
  
  static func == <Destination>(lhs: Self, rhs: StackNavigator<Destination>) -> Bool {
    lhs.optional?.id == ObjectIdentifier(rhs)
  }
  
  static func == <Destination>(lhs: StackNavigator<Destination>, rhs: Self) -> Bool {
    ObjectIdentifier(lhs) == rhs.optional?.id
  }
}

extension StackNavigator {
  func eraseToAnyStackNavigator() -> AnyStackNavigator {
    AnyStackNavigator(self)
  }
}
