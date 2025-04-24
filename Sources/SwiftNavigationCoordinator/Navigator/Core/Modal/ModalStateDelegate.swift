//
//  ModalStateDelegate.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
protocol ModalStateDelegate: AnyObject {
  func modalStateDidDismiss(_ destination: AnyDestination)
}

extension ModalStateDelegate {
  @_disfavoredOverload
  func eraseToAnyModalStateDelegate() -> AnyModalStateDelegate {
    AnyModalStateDelegate(self)
  }
  
  func eraseToAnyModalStateDelegate() -> AnyModalStateDelegate where Self == AnyModalStateDelegate {
    self
  }
}

@MainActor
final class AnyModalStateDelegate: ModalStateDelegate {
  private var _modalStateDidDismiss: ((AnyDestination) -> Void)!
  
  private(set) var isValid = true
  
  init<Delegate: ModalStateDelegate>(
    _ delegate: Delegate
  ) {
    assert(Delegate.self != AnyModalStateDelegate.self)
    
    _modalStateDidDismiss = { [weak self, weak delegate] in
      guard let delegate else {
        self?.isValid = false
        return
      }
      
      delegate.modalStateDidDismiss($0)
    }
  }
  
  func modalStateDidDismiss(_ destination: AnyDestination) {
    _modalStateDidDismiss(destination)
  }
}
