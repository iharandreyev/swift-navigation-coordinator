//
//  MultiChildFlowCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowDestination: String, DestinationType {
  case selectPath
  case pathA
  case pathB
  case confirmRestart
}

final class MultiChildFlowCoordinator: CoordinatorBase, StackCoordinatorType, ScreenCoordinatorType {
  typealias Destination = MultiChildFlowDestination

  func initialScreen() -> some View {
    MultiChildFlowRootScreen(
      onNext: { [unowned self] in
        Task(operation: showSelectPath)
      }
    )
  }

  func screen(for destination: Destination) -> some View {
    switch destination {
    case .selectPath:
      MultiChildFlowSelectPathScreen(
        onPathA: { [unowned self] in
          Task(operation: showPathA)
        },
        onPathB: { [unowned self] in
          Task(operation: showPathB)
        },
        onRestart: { [unowned self] in
          Task(operation: showConfirmRestart)
        }
      )
      .navigationTitle("Select Path")

    case .pathA:
      CoordinatedScreen.stackPage(
        stackCoordinator: child(
          ofType: MultiChildFlowPathACoordinator.self,
          for: destination
        )
      )

    case .pathB:
      CoordinatedScreen.base(
        modalCoordinator: child(
          ofType: MultiChildFlowPathBCoordinator.self,
          for: destination
        )
      )

    case .confirmRestart:
      MultiChildFlowConfirmRestartScreen(
        onRestart: { [unowned self] in
          Task(operation: restart)
        }
      )
    }
  }

  func showSelectPath() async {
    await navigator.push(Destination.selectPath)
  }

  func showConfirmRestart() async {
    await navigator.push(Destination.confirmRestart)
  }

  func showPathA() async {
    let destination = Destination.pathA
    
    addChild(
      childFactory: {
        MultiChildFlowPathACoordinator(navigator: Navigator.continue(navigator))
      },
      as: destination
    )

    await navigator.push(destination)
  }

  func showPathB() async {
    let destination = Destination.pathB
    
    addChild(
      childFactory: {
        MultiChildFlowPathBCoordinator(navigator: Navigator())
      },
      as: destination
    )

    await navigator.push(destination)
  }

  func restart() async {
    await navigator.popToRoot()
  }

  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    #warning("TODO: Ensure coordinator is in the correct state prior to firing navigation logic")
    switch deeplink {
    case Deeplink.showMultiChildPathA:
      await showPathA()
      return .partial
      
    case Deeplink.showMultiChildPathAFinish:
      await showPathA()
      return .partial
      
    case Deeplink.showMultiChildPathB:
      await showPathB()
      return .partial
      
    case Deeplink.showMultiChildPathBFinish:
      await showPathB()
      return .partial
      
    default:
      return .impossible
    }
  }
  
  override func handleChildEvent(
    _ event: any ChildEventType,
    sourceFile: StaticString = #file,
    line: UInt = #line
  ) async {
    switch event {
    case _ as MultiChildFlowPathAFinishEvent:
      await finish()
    case _ as MultiChildFlowPathBFinishEvent:
      await finish()
    default:
      return await super.handleChildEvent(event, sourceFile: sourceFile, line: line)
    }
  }
}
