//
//  ShortDescription.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import Foundation

struct ShortDescription: CustomStringConvertible {
  let description: String

  init(_ objectIdentifier: ObjectIdentifier) {
    var value = "\(objectIdentifier)"
    value.removeSubrange(value.startIndex ... "ObjectIdentifier".endIndex)
    value.removeLast()
    
    description = value
  }
  
  #warning("TODO: Get rid of regex in favor of linear string search")
  @_disfavoredOverload
  init<T>(_ value: T) {
    let afterFirstDotExpr =  try! Regex("\\.(.*)")
    let afterFirstGuillemetExpr = try! Regex("\\<(.*)")
    
    var components: [String] = ["\(value)"]
    
    while let last = components.last {
      var last = last
      
      if let afterFirstDotRng = last.firstMatch(
        of: afterFirstDotExpr
      )?.range {
        last = String(last[afterFirstDotRng].dropFirst())
      }
      
      guard let afterFirstGuillemetRng = last.firstMatch(
        of: afterFirstGuillemetExpr
      )?.range else {
        components.removeLast()
        components.append(last)
        
        break
      }
      
      let next = String(last[afterFirstGuillemetRng].dropFirst().dropLast())
      last.removeSubrange(afterFirstGuillemetRng)
      
      components.removeLast()
      components.append(last)
      components.append(next)
    }

    let numOfGenerics = components.count - 1
    
    guard numOfGenerics > 0 else {
      description = components[0]
      return
    }
    
    description = components.joined(
      separator: "<"
    )
    .appending(
      String(repeating: ">", count: numOfGenerics)
    )
  }
}

private extension String {
  @inline(__always)
  init(repeating value: String, count: Int) {
    assert(count > 0)
    self = Array(repeating: value, count: count).joined()
  }
}
