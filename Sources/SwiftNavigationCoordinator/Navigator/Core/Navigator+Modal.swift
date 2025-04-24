//
//  Navigator+Modal.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

extension Navigator {
  public func presentDestination<Destination: DestinationType>(
    _ destination: ModalDestinationPath<Destination>,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      update: { [weak _modalState] in
        _modalState?.setDestination(destination)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
  
  public func dismissDestination(
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      update: { [weak _modalState] in
        _modalState?.dismissDestination()
      },
      animated: animated,
      from: file,
      at: line
    )
  }
}

extension Navigator {
  @_disfavoredOverload
  public func modalDestination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> ModalDestinationPath<Destination>? {
    _modalState.destination(for: destinationType, invokedIn: file, at: line)
  }
  
  public func modalDestination() -> ModalDestinationPath<AnyDestination>? {
    _modalState._destination
  }
}
