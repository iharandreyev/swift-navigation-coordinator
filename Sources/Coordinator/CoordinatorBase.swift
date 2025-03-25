//
//  CoordinatorBase.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

/*
 Coordinator testing:
 - method invocation results with correct navigator state
 - create screen invokes correct method within factory
 */
@MainActor
open class CoordinatorBase {
  private(set) weak var parent: CoordinatorBase?
  private(set) public var children: [AnyDestination: CoordinatorBase] = [:]
  
  private var id: AnyDestination?
  private var onFinish: (() -> Void)?

  // MARK: - Init
  
  public init(
    onFinish: (() -> Void)? = nil
  ) {
    self.onFinish = onFinish

    #warning(
    """
      TODO: Shorten `self.description` string, 
      as it contains module information by default,
      making things unreadable
    """
    )
    logMessage("INIT: `\(self)`")
  }
  
  // MARK: - Deinit
  
  deinit {
    #warning(
    """
      TODO: Shorten `self.description` string, 
      as it contains module information by default,
      making things unreadable
    """
    )
    logMessage("DEINIT: `\(self)`")
  }
  
  // MARK: - Children Management
  
  @discardableResult
  public final func addChild<
    Child: CoordinatorBase,
    Destination: Sendable & Hashable
  >(
    childFactory createChild: () -> Child,
    as destination: Destination,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Child {
    if let child = children[AnyDestination(destination)] {
      guard let child = child as? Child else {
        #warning(
        """
          TODO: Shorten `Child.self.description` string, 
          as it contains module information by default,
          making things unreadable
        """
        )
        fatalError(
          """
            Type mismatch! \
            Expected `\(child)` to be of type `\(Child.self)`
          """,
          file: file,
          line: line
        )
      }
      
      return child
    }
    
    let child = createChild()
    
    addChild(
      child,
      as: destination,
      file: file,
      line: line
    )
    
    return child
  }
  
  public final func addChild<
    Child: CoordinatorBase,
    Destination: Sendable & Hashable
  >(
    _ child: Child,
    as destination: Destination,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    let anyDestination = AnyDestination(destination)
    
    guard children[anyDestination] == nil else {
      #warning(
      """
        TODO: Shorten `Child.self.description` string, 
        as it contains module information by default,
        making things unreadable
      """
      )
      fatalError(
        """
          `\(self)` already contains child of type `\(Child.self)`"
        """,
        file: file,
        line: line
      )
    }
    
    child.parent = self
    child.id = anyDestination
    
    children[anyDestination] = child
    
    logMessage("ADD: `\(child)` is added into `\(self)`")
  }
  
  public final func removeFromParent(
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let parent else { return }
    
    self.parent = nil
    
    if let id {
      parent.children.removeValue(forKey: id)
      return
    }
      
    for id in parent.children.keys {
      guard parent.children[id] == self else { continue }
      parent.children.removeValue(forKey: id)
      return
    }
    
    fatalError(
      "`\(self)` is not found in the `parent.children` list",
      file: file,
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
  
  open func finish() {
    removeFromParent()
    onFinish?()
    
    #warning(
    """
      TODO: Shorten `self.description` string, 
      as it contains module information by default,
      making things unreadable
    """
    )
    logMessage("FINISH: \(self)")
  }

  public final func setOnFinish(
    _ onFinish: @escaping () -> Void
  ) {
    self.onFinish = onFinish
  }
  
  // MARK: - Child Event Handler
  
  open func handleChildEvent(
    _ event: any ChildEventType,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let parent else {
      fatalError(
        "There's no handler for event `\(event)`",
        file: file,
        line: line
      )
    }
    
    return parent.handleChildEvent(
      event,
      file: file,
      line: line
    )
  }
  
  // MARK: - Deeplink Event Handler
  
  open func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) -> ProcessDeeplinkResult {
    .impossible
  }
  
  final public func handleDeeplink(
    _ deeplink: any DeeplinkEventType
  ) -> Bool {
    switch processDeeplink(deeplink) {
    case .impossible: return false
    case .partial: break
    case .done: return true
    }
    
    for child in children.values {
      guard child.handleDeeplink(deeplink) else { continue }
      return true
    }

    return false
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
