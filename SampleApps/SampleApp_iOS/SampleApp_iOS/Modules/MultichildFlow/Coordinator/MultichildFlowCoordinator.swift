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

final class MultiChildFlowCoordinator: CoordinatorBase, StackCoordinatorType, NavigationCoordinatorType {
  // MARK: - Navigation Coordinator

  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = DestinationNever
  typealias StackDestination = MultiChildFlowDestination

  func initialContent() -> some View {
    Container(
      coordinator: self
    ) { [unowned self] in
      MultiChildFlowRootScreen(
        onNext: { [unowned self] in
          Task(operation: showSelectPath)
        }
      )
    }
  }
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
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
      child(
        of: MultiChildFlowPathACoordinator.self,
        for: destination
      )
      .initialContent()

    case .pathB:
      child(
        of: MultiChildFlowPathBCoordinator.self,
        for: destination
      )
      .initialContent()

    case .confirmRestart:
      MultiChildFlowConfirmRestartScreen(
        onRestart: { [unowned self] in
          Task(operation: restart)
        }
      )
    }
  }

  // MARK: - Logic
  
  func showSelectPath() async {
    await push(.selectPath)
  }

  func showConfirmRestart() async {
    await push(.confirmRestart)
  }

  func showPathA() async {
    let destination = StackDestination.pathA
    
    addChild(
      for: destination
    ) { navigator in
      MultiChildFlowPathACoordinator(navigator: navigator)
    }

    await push(destination)
  }

  func showPathB() async {
    let destination = StackDestination.pathB
    
    addChild(
      for: destination
    ) {
      MultiChildFlowPathBCoordinator()
    }

    await push(destination)
  }

  func restart() async {
    await popToInitial()
  }
  
  // MARK: - Deeplink

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
