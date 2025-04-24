//
//  DestinationNever.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

#warning("TODO: Documentation")
public struct DestinationNever: SomeDestination {
  public let id: String
  
  init(id: String = "DestinationNever") {
    self.id = id
  }
}
