//
//  WithTimeout.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

#if canImport(IssueReporting)

import IssueReporting
import SwiftNavigationCoordinator

/// Used to limit wait time for async methods with no respect whether they can be cancelled or not.
///
/// - Throws: `TimeoutError`
@_disfavoredOverload
@inline(__always)
public func withTimeout<Out: Sendable>(
  _ timeout: Duration,
  perform job: @Sendable @escaping () async throws -> Out,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  function: StaticString = #function
) async throws -> Out {
  try await _withTimeout(
    timeout,
    perform: {
      try await job()
    },
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column,
    function: function
  )
}

/// Used to limit wait time for async methods with no respect whether they can be cancelled or not.
///
/// - Throws: `TimeoutError`
@inline(__always)
public func withTimeout(
  _ timeout: Duration,
  perform job: @Sendable @escaping () async throws -> Void,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  function: StaticString = #function
) async throws {
  do {
    try await _withTimeout(
      timeout,
      perform: {
        try await job()
      },
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column,
      function: function
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
  fileID: StaticString,
  filePath: StaticString,
  line: UInt,
  column: UInt,
  function: StaticString
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
    reportIssue(
      error,
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
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

#endif
