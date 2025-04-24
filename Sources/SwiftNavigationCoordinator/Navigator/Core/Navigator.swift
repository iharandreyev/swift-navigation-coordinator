//
//  Navigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

import OrderedCollections

@MainActor
public final class Navigator {
  private let createModalState: () -> ModalState
  private let createSpecimenState: () -> SpecimenState
  private let createStackState: () -> StackState
  
  let navigationQueue: AnyNavigationQueue
  
  // States are initialized lazily to avoid unnecessary init when appropriate states are not used by a coordinator
  private(set) lazy var _modalState: ModalState = {
    let state = createModalState()
    state.appendDelegate(self)
    return state
  }()
  
  private(set) lazy var _specimenState: SpecimenState = createSpecimenState()

  private(set) lazy var _stackState: StackState = {
    let state = createStackState()
    state.appendDelegate(self)
    return state
  }()
  
  weak var delegate: NavigatorDelegate?
  
  // MARK: - Init

  init<
    NavigationQueue: NavigationQueueType
  >(
    createModalState: @MainActor @Sendable @escaping () -> ModalState = { ModalState() },
    createSpecimenState: @MainActor @Sendable @escaping () -> SpecimenState = { SpecimenState() },
    createStackState: @MainActor @Sendable @escaping () -> StackState = { StackState() },
    navigationQueue: NavigationQueue
  ) {
    self.createModalState = createModalState
    self.createSpecimenState = createSpecimenState
    self.createStackState = createStackState
    self.navigationQueue = navigationQueue.eraseToAnyNavigationQueue()
  }
  
  convenience init<
    ModalDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createModalState: {
        ModalState(initialDestination: initialModalDestination)
      },
      navigationQueue: navigationQueue
    )
  }
  
  convenience init<
    SpecimenDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialSpecimenDestination: SpecimenDestination,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      navigationQueue: navigationQueue
    )
  }

  convenience init<
    NavigationQueue: NavigationQueueType
  >(
    initialStack: OrderedSet<AnyIdentifiableDestination>,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createStackState: {
        StackState(initialStack: initialStack)
      },
      navigationQueue: navigationQueue
    )
  }
  
  convenience init<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialSpecimenDestination: SpecimenDestination,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createModalState: {
        ModalState(initialDestination: initialModalDestination)
      },
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      navigationQueue: navigationQueue
    )
  }
  
  convenience init<
    SpecimenDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialSpecimenDestination: SpecimenDestination,
    initialStack: OrderedSet<AnyIdentifiableDestination>,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      createStackState: {
        StackState(initialStack: initialStack)
      },
      navigationQueue: navigationQueue
    )
  }
  
  convenience init<
    ModalDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialStack: OrderedSet<AnyIdentifiableDestination>,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createModalState: {
        ModalState(initialDestination: initialModalDestination)
      },
      createStackState: {
        StackState(initialStack: initialStack)
      },
      navigationQueue: navigationQueue
    )
  }
  
  convenience init<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType,
    NavigationQueue: NavigationQueueType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialSpecimenDestination: SpecimenDestination,
    initialStack: OrderedSet<AnyIdentifiableDestination>,
    navigationQueue: NavigationQueue
  ) {
    self.init(
      createModalState: {
        ModalState(initialDestination: initialModalDestination)
      },
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      createStackState: {
        StackState(initialStack: initialStack)
      },
      navigationQueue: navigationQueue
    )
  }
  
  public convenience init<
    ModalDestination: DestinationType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>
  ) {
    self.init(
      initialModalDestination: initialModalDestination,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init<
    SpecimenDestination: DestinationType
  >(
    initialSpecimenDestination: SpecimenDestination
  ) {
    self.init(
      initialSpecimenDestination: initialSpecimenDestination,
      navigationQueue: NavigationQueue.live
    )
  }

  public convenience init(
    initialStack: OrderedSet<AnyIdentifiableDestination>
  ) {
    self.init(
      initialStack: initialStack,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialSpecimenDestination: SpecimenDestination
  ) {
    self.init(
      initialModalDestination: initialModalDestination,
      initialSpecimenDestination: initialSpecimenDestination,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init<
    SpecimenDestination: DestinationType
  >(
    initialSpecimenDestination: SpecimenDestination,
    initialStack: OrderedSet<AnyIdentifiableDestination>
  ) {
    self.init(
      initialSpecimenDestination: initialSpecimenDestination,
      initialStack: initialStack,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init<
    ModalDestination: DestinationType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialStack: OrderedSet<AnyIdentifiableDestination>
  ) {
    self.init(
      initialModalDestination: initialModalDestination,
      initialStack: initialStack,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init<
    ModalDestination: DestinationType,
    SpecimenDestination: DestinationType
  >(
    initialModalDestination: ModalDestinationPath<ModalDestination>,
    initialSpecimenDestination: SpecimenDestination,
    initialStack: OrderedSet<AnyIdentifiableDestination>
  ) {
    self.init(
      initialModalDestination: initialModalDestination,
      initialSpecimenDestination: initialSpecimenDestination,
      initialStack: initialStack,
      navigationQueue: NavigationQueue.live
    )
  }
  
  public convenience init() {
    self.init(navigationQueue: NavigationQueue.live)
  }

  public static func `continue`(_ parent: Navigator) -> Navigator {
    let stackState = parent._stackState
    let navigationQueue = parent.navigationQueue
    
    return Navigator(
      createStackState: { stackState },
      navigationQueue: navigationQueue
    )
  }
}

extension Navigator: ModalStateDelegate {
  func modalStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    delegate?.navigatorDidDismissModalDestination(destination)
  }
}

extension Navigator: StackStateDelegate {
  func stackStateDidDismiss(_ destination: AnyIdentifiableDestination) {
    delegate?.navigatorDidDismissStackDestination(destination)
  }
}
