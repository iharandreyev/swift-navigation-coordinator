//
//  MultiChildFlowPathBCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowPathBDestination: String, DestinationType {
  case finish
  
  var id: String {
    rawValue
  }
}

final class MultiChildFlowPathBCoordinator: CoordinatorBase, ModalCoordinatorType, ScreenCoordinatorType {
  // MARK: - Navigation Coordinator

  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = MultiChildFlowPathBDestination
  typealias StackDestination = DestinationNever

  func initialScreen() -> some View {
    MultiChildFlowPathBInitialScreen(
      onProceed: { [unowned self] in
        Task(operation: proceedToFinishFlow)
      }
    )
  }
  
  @ViewBuilder
  func content(forSpecimen destination: SpecimenDestination) -> some View {
    EmptyView()
  }

  @ViewBuilder
  func content(forModal destination: ModalDestination) -> some View {
    switch destination {
    case .finish:
      MultiChildFlowFinishScreen(
        onDone: { [unowned self] in
          Task(operation: finishFlow)
        }
      )
    }
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    EmptyView()
  }

  // MARK: - Logic
  
  func proceedToFinishFlow() async {
    await presentDestination(.cover(.finish))
  }
  
  func finishFlow() async {
    await dismissDestination()
    await handleChildEvent(MultiChildFlowPathBFinishEvent())
  }
  
  // MARK: - Deeplink
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    #warning("TODO: Ensure coordinator is in the correct state prior to firing navigation logic")
    switch deeplink {
    case Deeplink.showMultiChildPathB:
      print("Deeplink.showMultiChildPathB: DONE")
      return .done
      
    case Deeplink.showMultiChildPathBFinish:
      await proceedToFinishFlow()
      return .done
      
    default:
      return .impossible
    }
  }
}

struct MultiChildFlowPathBFinishEvent: ChildEventType { }
