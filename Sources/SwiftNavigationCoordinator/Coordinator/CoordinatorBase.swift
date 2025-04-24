//
//  CoordinatorBase.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

#warning("TODO: Documentation")
@MainActor
open class CoordinatorBase: NavigatorDelegate {
  private(set) weak var parent: CoordinatorBase?
  private(set) public var children: [AnyDestination: CoordinatorBase] = [:]
  
  private(set) lazy var id = AnyDestination(
    DestinationNever(id: ShortDescription(self).description)
  )
  
  private var onFinish: Callback<Void>?
  
  private(set) var isFinished: Bool = false
  
  public let navigator: Navigator

  // MARK: - Init
  
  public init(
    navigator: Navigator = Navigator(),
    onFinish: Callback<Void>? = nil
  ) {
    self.navigator = navigator
    self.onFinish = onFinish
    
    navigator.delegate = self

    logMessage("INIT: `\(ShortDescription(self))`")
  }
  
  // MARK: - Deinit
  
  deinit {
    logMessage("DEINIT: `\(ShortDescription(self))`")
  }
  
  // MARK: - Children Management

  public final func addChild<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    _ child: Child,
    for destination: Destination,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    let anyDestination = AnyDestination(destination)
    
    guard children[anyDestination] == nil else {
      return logWarning(
        """
          `\(ShortDescription(self))` already contains child of type 
          `\(ShortDescription(Child.self))`"                          \
          Ignore `addChild`
        """,
        invokedIn: file,
        at: line
      )
    }
    
    child.parent = self
    child.id = anyDestination
    
    children[anyDestination] = child
    
    logMessage(
      """
        ADD: `\(ShortDescription(child))` is added 
        into `\(ShortDescription(self))`
      """
    )
  }
  
  public final func removeFromParent(
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    guard let parent else { return }
    
    self.parent = nil
    
    if parent.children.keys.contains(id) {
      parent.children.removeValue(forKey: id)
      return
    }
      
    for id in parent.children.keys {
      guard parent.children[id] == self else { continue }
      parent.children.removeValue(forKey: id)
      return
    }
    
    fatalError(
      "\(ShortDescription(self))` is not found in the `parent.children` list",
      invokedIn: file,
      at: line
    )
  }
  
  public final func removeAllChildren() {
    children.values.forEach {
      $0.parent = nil
    }
    children.removeAll()
  }
  
  // MARK: - Life Cycle
  
  open func finish(
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    guard !isFinished else {
      return logWarning(
        """
          Trying to finish `\(ShortDescription(self))` that has already been finished \
          This is a programming error
        """,
        invokedIn: file,
        at: line
      )
    }
    
    await onFinish?.execute()
    
    removeFromParent(
      invokedIn: file,
      at: line
    )
    
    isFinished = true
    onFinish = nil
    
    logMessage("FINISH: \(ShortDescription(self))")
  }
  
  @_disfavoredOverload
  final func finish(
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) {
    Task { [weak self] in
      await self?.finish(
        invokedIn: file,
        at: line
      )
    }
  }
  
  public final func setOnFinish(
    _ onFinish: Callback<Void>
  ) {
    self.onFinish = onFinish
  }
  
  // MARK: - Child Event Handler
  
  public final func sendChildEvent(
    _ event: any ChildEventType,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    guard let parent else {
      fatalError(
        "There's no handler for event `\(ShortDescription(event))`",
        invokedIn: file,
        at: line
      )
    }
    
    if await parent.handleChildEvent(event) { return }
    
    return await parent.sendChildEvent(
      event,
      invokedIn: file,
      at: line
    )
  }
  
  open func handleChildEvent(
    _ event: any ChildEventType
  ) async -> Bool {
    false
  }
  
  // MARK: - Deeplink Event Handler
  
  open func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    .impossible
  }
  
  final public func handleDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> Bool {
    switch await processDeeplink(deeplink) {
    case .impossible: return false
    case .partial: break
    case .done: return true
    }
    
    for child in children.values {
      guard await child.handleDeeplink(deeplink) else { continue }
      return true
    }

    return false
  }
  
  // MARK: - Navigator Delegate
  
  open func navigatorDidDismissModalDestination(_ destination: AnyDestination) {
    switch destination {
    case id:
      finish()
    default:
      child(for: destination)?.finish()
    }
  }
  
  open func navigatorDidDismissStackDestination(_ destination: AnyDestination) {
    switch destination {
    case id:
      finish()
    default:
      child(for: destination)?.finish()
    }
  }
}

extension CoordinatorBase {
  static func == (lhs: CoordinatorBase, rhs: CoordinatorBase) -> Bool {
    ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
  }
  
  static func == (lhs: CoordinatorBase?, rhs: CoordinatorBase) -> Bool {
    false
  }
  
  static func == (lhs: CoordinatorBase, rhs: CoordinatorBase?) -> Bool {
    false
  }
}

#if canImport(XCTest)

extension CoordinatorBase {
  func testOnFinish() -> Callback<Void>? {
    onFinish
  }
}

#endif
