//
//  CoordinatorType.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/31/25.
//

/// A protocol that every coordinator is recommended to conform to.
///
/// Injecting abstract `factory` property is useful to ensure coordinator testability.
/// One can observe which methods the coordinator invokes when state changes, or when some navigation is performed.
@MainActor
public protocol CoordinatorType: CoordinatorBase {
  associatedtype FactoryDelegateType: CoordinatorFactoryDelegateType
  
  var factory: FactoryDelegateType { get }
}

@MainActor
public protocol CoordinatorFactoryDelegateType { }

#warning(
  """
    TODO: Implement macros

    @Coordinator
    class SomeCoordinator { }

    expands into 

    class SomeCoordinator: CoordinatorBase, CoordinatorType { 
      let factory: FactoryDelegateType
    }

    @CoordinatorFactoryDelegate
    protocol SomeCoordinatorFactoryDelegateType { }

    expands into

    protocol SomeCoordinatorFactoryDelegate: CoordinatorFactoryDelegateType {

    }

    final class SomeCoordinatorFactoryDelegateMock: SomeCoordinatorFactoryDelegate {
      // mock properties
    }
  """
)
