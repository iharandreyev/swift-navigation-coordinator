//
//  NavigationQueueType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
protocol NavigationQueueType: Sendable {
  func schedule(
    sourceFile: StaticString,
    line: UInt,
    function: StaticString,
    animated: Bool,
    update: @MainActor @Sendable @escaping () -> Void
  ) async
}

extension NavigationQueueType {
  func schedule(
    sourceFile: StaticString,
    line: UInt,
    function: StaticString = #function,
    animated: Bool = true,
    update: @MainActor @Sendable @escaping () -> Void
  ) async {
    await schedule(
      sourceFile: sourceFile,
      line: line,
      function: function,
      animated: animated,
      update: update
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
