//
//  MutableValue.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

public actor MutableValue<Value: Sendable>: Sendable {
  private(set) public var value: Value
  
  public init(value: Value) {
    self.value = value
  }
  
  public func setValue(_ newValue: Value) {
    value = newValue
  }
}
