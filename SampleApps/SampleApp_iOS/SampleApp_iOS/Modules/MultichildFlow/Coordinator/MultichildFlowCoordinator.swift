//
//  MultiChildFlowCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowDestination: ScreenDestinationType {
  case selectPath
  case pathA
  case pathB
  case confirmRestart
}

final class MultiChildFlowCoordinator: CoordinatorBase, StackCoordinatorType, ScreenCoordinatorType, CoordinatorChildSearch {
  typealias DestinationType = MultiChildFlowDestination

  let stackNavigator: StackNavigator<DestinationType>

  init(
    stackNavigator: StackNavigator<DestinationType>,
    onFinish: Callback<Void>? = nil
  ) {
    self.stackNavigator = stackNavigator

    super.init(onFinish: onFinish)
  }

  func initialScreen() -> some View {
    MultiChildFlowRootScreen(
      onNext: { [unowned self] in
        Task(operation: showSelectPath)
      }
    )
    .onRemoveFromHierarchy(finish: self)
  }

  func screen(for destination: DestinationType) -> some View {
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
          for: .pathA
        )
      )

    case .pathB:
      CoordinatedScreen.base(
        modalCoordinator: child(
          ofType: MultiChildFlowPathBCoordinator.self,
          for: .pathB
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
    await stackNavigator.push(.selectPath)
  }

  func showConfirmRestart() async {
    await stackNavigator.push(.confirmRestart)
  }

  func showPathA() async {
    addChild(
      childFactory: {
        MultiChildFlowPathACoordinator(stackNavigator: stackNavigator.scope())
      },
      as: DestinationType.pathA
    )

    await stackNavigator.push(.pathA)
  }

  func showPathB() async {
    addChild(
      childFactory: {
        MultiChildFlowPathBCoordinator(modalNavigator: ModalNavigator())
      },
      as: DestinationType.pathB
    )

    await stackNavigator.push(.pathB)
  }

  func restart() async {
    await stackNavigator.popToRoot()
  }

  override func handleChildEvent(
    _ event: any ChildEventType,
    file: StaticString = #file,
    line: UInt = #line
  ) async {
    switch event {
    case _ as MultiChildFlowPathAFinishEvent:
      await finish()
    case _ as MultiChildFlowPathBFinishEvent:
      await finish()
    default:
      return await super.handleChildEvent(event, file: file, line: line)
    }
  }
}
