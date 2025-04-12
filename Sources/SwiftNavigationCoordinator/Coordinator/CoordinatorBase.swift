//
//  CoordinatorBase.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

@MainActor
open class CoordinatorBase {
  private(set) weak var parent: CoordinatorBase?
  private(set) public var children: [AnyDestination: CoordinatorBase] = [:]
  
  private var id: AnyDestination?
  private var onFinish: Callback<Void>?

  // MARK: - Init
  
  public init(
    onFinish: Callback<Void>? = nil
  ) {
    self.onFinish = onFinish

    logMessage("INIT: `\(ShortDescription(self))`")
  }
  
  public convenience init(
    onFinish: @Sendable @escaping () -> Void
  ) {
    self.init(onFinish: Callback(job: onFinish))
  }
  
  // MARK: - Deinit
  
  deinit {
    logMessage("DEINIT: `\(ShortDescription(self))`")
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
        fatalError(
          """
            Type mismatch!                                        \
            Expected `\(ShortDescription(child))` to be of type 
            `\(ShortDescription(Child.self))`                     \
            Source: \(file):\(line)
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
      fatalError(
        """
          `\(ShortDescription(self))` already contains child of type 
          `\(ShortDescription(Child.self))`"                          \
          Source: \(file):\(line)
        """,
        file: file,
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
      """
        `\(ShortDescription(self))` is not found in the `parent.children` list. \
        Source: \(file):\(line)
      """,
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
  
  open func finish(
    file: StaticString = #file,
    line: UInt = #line
  ) {
    removeFromParent(
      file: file,
      line: line
    )
    
    onFinish?()
    
    logMessage("FINISH: \(ShortDescription(self))")
  }

  public final func setOnFinish(
    _ onFinish: @Sendable @escaping () -> Void
  ) {
    self.onFinish = Callback(job: onFinish)
  }
  
  public final func setOnFinish(
    _ onFinish: Callback<Void>
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
        """
          There's no handler for event `\(ShortDescription(event))` \
          Source: \(file):\(line)
        """,
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
