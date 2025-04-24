//
//  Navigator.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

@MainActor
public final class Navigator {
  private let createSpecimenState: () -> SpecimenState
  private let createModalState: () -> ModalState
  private let createStackState: () -> StackState
  
  let navigationQueue: AnyNavigationQueue
  
  // States are initialized lazily to avoid unnecessary init when appropriate states are not used by a coordinator
  private(set) lazy var _specimenState: SpecimenState = createSpecimenState()
  
  private(set) lazy var _modalState: ModalState = {
    let state = createModalState()
    state.appendDelegate(self)
    return state
  }()
  
  private(set) lazy var _stackState: StackState = {
    let state = createStackState()
    state.appendDelegate(self)
    return state
  }()
  
  weak var delegate: NavigatorDelegate?
  
  // MARK: - Init

  init<NavigationQueue: NavigationQueueType>(
    createSpecimenState: @MainActor @Sendable @escaping () -> SpecimenState = { SpecimenState() },
    createModalState: @MainActor @Sendable @escaping () -> ModalState = { ModalState() },
    createStackState: @MainActor @Sendable @escaping () -> StackState = { StackState() },
    navigationQueue: NavigationQueue
  ) {
    self.createSpecimenState = createSpecimenState
    self.createModalState = createModalState
    self.createStackState = createStackState
    self.navigationQueue = navigationQueue.eraseToAnyNavigationQueue()
  }
  
  public convenience init() {
    self.init(navigationQueue: Environment.navigationQueue)
  }
  
  public convenience init<SpecimenDestination: Hashable & Identifiable & Sendable>(
    initialSpecimenDestination: SpecimenDestination
  ) {
    self.init(
      createSpecimenState: {
        SpecimenState(initialDestination: initialSpecimenDestination)
      },
      navigationQueue: Environment.navigationQueue
    )
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
