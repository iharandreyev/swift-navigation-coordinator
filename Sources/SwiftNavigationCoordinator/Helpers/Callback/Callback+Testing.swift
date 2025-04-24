//
//  Callback+Testing.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#if canImport(IssueReporting)

import IssueReporting

extension Callback {
  //  Had to make this public since #if canImport(Testing) does not work when importing stuff from another package
  //  https://forums.swift.org/t/xcode-not-respecting-canimport-xctest/46826
  public func onCompleted(
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    at line: UInt = #line,
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
}

#endif
