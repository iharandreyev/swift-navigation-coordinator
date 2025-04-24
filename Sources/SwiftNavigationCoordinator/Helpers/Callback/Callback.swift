//
//  Callback.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import IssueReporting

public actor Callback<Params: Sendable>: Sendable {
  typealias Completion = @Sendable () -> Void
  
  private let job: @Sendable (Params) async -> Void

  let completion: MutableValue<Task<Void, any Error>?> = MutableValue(value: nil)
  
  public init(
    job: @Sendable @escaping (Params) async -> Void
  ) {
    self.job = job
  }
  
  nonisolated public func callAsFunction(_ params: Params) {
    Task {
      await execute(params)
    }
  }
  
  public func execute(_ params: Params) async {
    await createCompletionIfNeeded()
    await job(params)
    await resolveCompletion()
  }

  func createCompletionIfNeeded() async {
    guard await completion.value == nil else { return }
    let task = veryLongDelayTask()
    await completion.setValue(task)
  }

  private func resolveCompletion() async {
    await completion.value?.cancel()
    await completion.setValue(nil)
  }

  private func veryLongDelayTask() -> Task<Void, any Error> {
    Task {
      try await Task.sleep(for: .seconds(86400)) // a day
    }
  }
}

extension Callback where Params == Void {
  @inline(__always)
  nonisolated public func callAsFunction() {
    callAsFunction(())
  }
  
  @inline(__always)
  public func execute() async {
    await execute(())
  }
}
