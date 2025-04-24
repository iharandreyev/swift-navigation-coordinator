//
//  StackStateDelegate.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
protocol StackStateDelegate: AnyObject {
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination)
}

extension StackStateDelegate {
  @_disfavoredOverload
  func eraseToAnyStackStateDelegate() -> AnyStackStateDelegate {
    AnyStackStateDelegate(self)
  }
  
  func eraseToAnyNavigationQueue() -> AnyStackStateDelegate where Self == AnyStackStateDelegate {
    self
  }
}

@MainActor
final class AnyStackStateDelegate: StackStateDelegate {
  private var _stackStateDidDismiss: ((AnyIdentifiableDestination) -> Void)!
  
  private(set) var isValid = true
  
  init<Delegate: StackStateDelegate>(
    _ delegate: Delegate
  ) {
    assert(Delegate.self != AnyStackStateDelegate.self)
    
    _stackStateDidDismiss = { [weak self, weak delegate] in
      guard let delegate else {
        self?.isValid = false
        return
      }
      
      delegate.stackStateDidDismiss($0)
    }
  }
  
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    _stackStateDidDismiss(destination)
  }
}
