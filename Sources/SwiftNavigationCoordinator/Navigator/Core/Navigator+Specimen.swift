//
//  Navigator+Specimen.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/24/25.
//

extension Navigator {
  public func replaceSpecimenDestination<Destination: DestinationType>(
    with destination: Destination,
    animated: Bool = true,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      update: { [weak _specimenState] in
        _specimenState?.setDestination(destination)
      },
      animated: animated,
      from: file,
      at: line
    )
  }
}

extension Navigator {
  @_disfavoredOverload
  public func specimenDestination<Destination: SomeDestination>(
    for destinationType: Destination.Type = Destination.self,
    invokedIn file: StaticString = #file,
    at line: UInt = #line
  ) -> Destination {
    _specimenState.destination(for: destinationType, invokedIn: file, at: line)
  }
  
  public func specimenDestination() -> AnyDestination {
    _specimenState._destination
  }
}
