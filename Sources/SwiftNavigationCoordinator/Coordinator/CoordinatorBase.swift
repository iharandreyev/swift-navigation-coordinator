//
//  CoordinatorBase.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

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
  
  @discardableResult
  public final func addChild<
    Child: CoordinatorBase,
    Destination: SomeDestination
  >(
    _ child: Child,
    for destination: Destination,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    let anyDestination = AnyDestination(destination)
    
    guard children[anyDestination] == nil else {
      fatalError(
        """
          `\(ShortDescription(self))` already contains child of type 
          `\(ShortDescription(Child.self))`"                          
        """,
        sourceFile: sourceFile,
        line: line
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
    
    return child
  }
  
  public final func removeFromParent(
    sourceFile: StaticString = #file,
    line: UInt = #line
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
      sourceFile: sourceFile,
      line: line
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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    guard !isFinished else {
      return logWarning(
        """
          Trying to finish `\(ShortDescription(self))` that has already been finished \
          This is a programming error
        """,
        file: sourceFile,
        line: line
      )
    }
    
    await onFinish?.execute()
    
    removeFromParent(
      sourceFile: sourceFile,
      line: line
    )
    
    isFinished = true
    onFinish = nil
    
    logMessage("FINISH: \(ShortDescription(self))")
  }
  
  @_disfavoredOverload
  final func finish(
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) {
    Task { [weak self] in
      await self?.finish(sourceFile: sourceFile, line: line)
    }
  }
  
  public final func setOnFinish(
    _ onFinish: Callback<Void>
  ) {
    self.onFinish = onFinish
  }
  
  // MARK: - Child Event Handler
  
  open func handleChildEvent(
    _ event: any ChildEventType,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    guard let parent else {
      fatalError(
        "There's no handler for event `\(ShortDescription(event))`",
        sourceFile: sourceFile,
        line: line
      )
    }
    
    return await parent.handleChildEvent(
      event,
      sourceFile: sourceFile,
      line: line
    )
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
