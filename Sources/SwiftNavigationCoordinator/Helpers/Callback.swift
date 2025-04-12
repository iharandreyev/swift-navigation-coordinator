//
//  Callback.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

import IssueReporting

public final class Callback<Params: Sendable>: Sendable {
  private typealias Completion = @Sendable () -> Void
  
  private let job: @Sendable (Params) async -> Void

  private let completion: MutableValue<Task<Void, any Error>?> = MutableValue(value: nil)
  
  public init(
    job: @Sendable @escaping (Params) async -> Void
  ) {
    self.job = job
  }
  
  public func callAsFunction(_ params: Params) {
    Task {
      await execute(params)
    }
  }
  
  public func execute(_ params: Params) async {
    await createCompletionIfNeeded()
    await job(params)
    await resolveCompletion()
  }
  
  //  Had to make this public since #if canImport(Testing) does not work when importing stuff from another package
  //  https://forums.swift.org/t/xcode-not-respecting-canimport-xctest/46826
  public func onCompleted(
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
  ) async {
    await createCompletionIfNeeded()
    do {
      try await completion.value?.value
    } catch _ as CancellationError {
      return
    } catch {
      reportIssue(
        error,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    }
  }

  private func createCompletionIfNeeded() async {
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
  public func callAsFunction() {
    callAsFunction(())
  }
  
  @inline(__always)
  public func execute() async {
    await execute(())
  }
}
