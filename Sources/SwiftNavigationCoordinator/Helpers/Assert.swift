//
//  Assert.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@inline(__always)
func assert<Value, Target>(
  _ value: Value,
  is targetType: Target.Type,
  sourceFile: StaticString = #file,
  line: UInt = #line
) -> Bool {
  guard value is Target else {
    logWarning(
      """
        Type mismatch. `\(value)` of type `\(Value.self)` can't be cast into `\(targetType)`
      """,
      file: sourceFile,
      line: line
    )
    return false
  }
  return true
}

@inline(__always)
func assert<Value, Target>(
  contentsOf optional: Value?,
  is targetType: Target.Type,
  sourceFile: StaticString = #file,
  line: UInt = #line
) -> Bool {
  guard let optional else { return true }
  
  return assert(
    optional,
    is: targetType,
    sourceFile: sourceFile,
    line: line
  )
}
