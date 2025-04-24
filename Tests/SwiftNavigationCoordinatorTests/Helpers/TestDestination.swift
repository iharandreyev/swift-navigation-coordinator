//
//  TestDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections
import SwiftNavigationCoordinator

enum TestDestinationOf<Tag: TestTagType>: String, DestinationType {
  typealias Tag = Tag
  
  case first
  case second
  case third
  case fourth
  case fifth
  case last
}

extension TestDestinationOf: CustomStringConvertible {
  var description: String {
    if Tag.self == Tags.Default.self {
      return rawValue
    } else {
      return "\(rawValue)<\(Tag.name)>"
    }
  }
}

typealias TestDestination = TestDestinationOf<Tags.Default>

protocol TestTagType {
  static var name: String { get }
}

enum Tags {
  struct Default: TestTagType {
    static let name = "Default"
  }
  
  struct T1: TestTagType {
    static let name = "T1"
  }
  
  struct T2: TestTagType {
    static let name = "T2"
  }
  
  struct T3: TestTagType {
    static let name = "T3"
  }
}
