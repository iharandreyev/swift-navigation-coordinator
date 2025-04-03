//
//  Callback.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/4/25.
//

#if canImport(XCTest)
import Testing
#endif

public final class Callback<Params: Sendable>: Sendable {
  private typealias Completion = @Sendable () -> Void
  
  private let job: @Sendable (Params) async -> Void

#if canImport(XCTest)
  private let completion: MutableValue<Task<Void, any Error>?> = MutableValue(value: nil)
#endif
  
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
#if canImport(XCTest)
    await createCompletionIfNeeded()
#endif
    await job(params)
#if canImport(XCTest)
    await resolveCompletion()
#endif
  }
  
#if canImport(XCTest)
  func onCompleted(sourceLocation: Testing.SourceLocation = #_sourceLocation) async {
    await createCompletionIfNeeded()
    do {
      try await completion.value?.value
    } catch _ as CancellationError {
      return
    } catch {
      Issue.record(error, sourceLocation: sourceLocation)
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
#endif
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
