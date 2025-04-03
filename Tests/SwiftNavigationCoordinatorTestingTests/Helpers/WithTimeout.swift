//
//  WithTimeout.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

import SwiftNavigationCoordinator
import Testing

/// Used to limit wait time for async methods with no respect whether they can be cancelled or not.
///
/// - Throws: `TimeoutError`
@_disfavoredOverload
@inline(__always)
public func withTimeout<Out: Sendable>(
  _ timeout: Duration,
  perform job: @Sendable @escaping () async throws -> Out,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws -> Out {
  try await _withTimeout(
    timeout,
    perform: {
      try await job()
    },
    function: function,
    sourceLocation: sourceLocation
  )
}

/// Used to limit wait time for async methods with no respect whether they can be cancelled or not.
///
/// - Throws: `TimeoutError`
@inline(__always)
public func withTimeout(
  _ timeout: Duration,
  perform job: @Sendable @escaping () async throws -> Void,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
  do {
    try await _withTimeout(
      timeout,
      perform: {
        try await job()
      },
      function: function,
      sourceLocation: sourceLocation
    )
  } catch _ as TimeoutError {
    return
  } catch {
    throw error
  }
}

private func _withTimeout<Out: Sendable>(
  _ timeout: Duration,
  perform job: @Sendable @escaping () async throws -> Out,
  function: StaticString,
  sourceLocation: Testing.SourceLocation
) async throws -> Out {
  let result = MutableValue<TimeoutableResult<Out>?>(value: nil)
  
  await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
    func finish(with _result: TimeoutableResult<Out>) async {
      guard await result.value == nil else { return }
      await result.setValue(_result)
      continuation.resume()
    }
    
    let jobTask = Task {
      let value = try await job()
      try Task.checkCancellation()
      return value
    }
    
    let timeoutTask = Task {
      try await Task.sleep(for: timeout)
      await finish(with: .timeout)
      jobTask.cancel()
    }
    
    Task {
      defer {
        timeoutTask.cancel()
        jobTask.cancel()
      }

      do {
        let value = try await jobTask.value
        await finish(with: .success(value))
      } catch {
        await finish(with: .failure(error))
      }
    }
  }
  
  switch await result.value {
  case let .success(value):
    return value
  case let .failure(error):
    throw error
  default:
    let error = TimeoutError(
      timeout: timeout,
      function: function
    )
    Issue.record("\(error)", sourceLocation: sourceLocation)
    throw error
  }
}

private enum TimeoutableResult<T: Sendable>: Sendable {
  case success(T)
  case failure(Error)
  case timeout
}

private struct TimeoutError: Error, CustomStringConvertible {
  let timeout: Duration
  let function: StaticString
  
  var description: String {
    "\(function) timed out after \(timeout)"
  }
}
