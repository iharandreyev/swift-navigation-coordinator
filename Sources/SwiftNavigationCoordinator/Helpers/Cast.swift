//
//  Cast.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@inline(__always)
func cast<In, Out>(
  _ value: In,
  into outType: Out.Type = Out.self,
  sourceFile: StaticString = #file,
  line: UInt = #line
) -> Out {
  guard let out = value as? Out else {
    fatalError(
      """
        Type mismatch!                                        \
        Expected `\(ShortDescription(value))` to be of type 
        `\(ShortDescription(outType))`                     
      """,
      sourceFile: sourceFile,
      line: line
    )
  }
  return out
}
