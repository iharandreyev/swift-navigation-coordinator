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
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _modalState] in
      _modalState?.setDestination(destination)
    }
  }
  
  public func dismissDestination(
    animated: Bool = true,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    await navigationQueue.schedule(
      sourceFile: sourceFile,
      line: line,
      animated: animated
    ) { [weak _modalState] in
      _modalState?.dismissDestination()
    }
  }
}
