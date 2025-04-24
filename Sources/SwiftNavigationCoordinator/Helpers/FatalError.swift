//
//  FatalError.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@inline(__always)
func fatalError(
  _ message: @autoclosure () -> String,
  invokedIn file: StaticString = #file,
  at line: UInt = #line
) -> Never {
  fatalError(
    """
      \(message()).                  \
      Invoked in: \(file):\(line)
    """,
    file: file,
    line: line
  )
}
