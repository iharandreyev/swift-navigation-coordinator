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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _specimenState] in
      _specimenState?.setDestination(destination)
    }
  }
}
