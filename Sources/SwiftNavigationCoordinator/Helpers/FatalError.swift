//
//  FatalError.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@inline(__always)
func fatalError(
  _ message: @autoclosure () -> String,
  sourceFile: StaticString = #file,
  line: UInt = #line
) -> Never {
  fatalError(
    """
      \(message()).                  \
      Source: \(sourceFile):\(line)
    """,
    file: sourceFile,
    line: line
  )
}
