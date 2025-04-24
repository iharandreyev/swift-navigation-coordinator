//
//  NavigationQueueType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

typealias NavigationQueueUpdate = @MainActor @Sendable () -> Void

@MainActor
protocol NavigationQueueType: Sendable {
  func schedule(
    update: @MainActor @Sendable @escaping () -> Void,
    animated: Bool,
    invokedIn function: StaticString,
    from file: StaticString,
    at line: UInt
  ) async
}

extension NavigationQueueType {
  func schedule(
    update: @escaping NavigationQueueUpdate,
    animated: Bool = true,
    invokedIn function: StaticString = #function,
    from file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await schedule(
      update: update,
      animated: animated,
      invokedIn: function,
      from: file,
      at: line
    )
  }
  
  @_disfavoredOverload
  func eraseToAnyNavigationQueue() -> AnyNavigationQueue {
    AnyNavigationQueue(self)
  }
  
  func eraseToAnyNavigationQueue() -> AnyNavigationQueue where Self == AnyNavigationQueue {
    self
  }
}

//enum OperationType {
//  case push(Operation)
//  case replaceLast(Operation)
//  case replacePath(Operation)
//  case pop(Operation)
//  case popToDestination(Operation)
//  case popToRoot(Operation)
//  case replaceRoot(Operation)
//  case presentModal(Operation)
//  case dismissModal(Operation)
//}
//
//struct Operation {
//  struct Step {
//    let animated: Bool
//    let job: () -> Void
//  }
//
//  let sourceFile: StaticString
//  let line: UInt
//  let steps: [Step]
//
//  init(sourceFile: StaticString, line: UInt, steps: [Step]) {
//    self.steps = steps
//    self.sourceFile = sourceFile
//    self.line = line
//  }
//
//  init(sourceFile: StaticString, line: UInt, animated: Bool, job: @escaping () -> Void) {
//    self.steps = [Step(animated: animated, job: job)]
//    self.sourceFile = sourceFile
//    self.line = line
//  }
//}
