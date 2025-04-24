//
//  MultiChildFlowPathACoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowPathADestination: String, DestinationType {
  case finish
}

final class MultiChildFlowPathACoordinator: CoordinatorBase, StackCoordinatorType, NavigationCoordinatorType {
  // MARK: - Navigation Coordinator

  typealias SpecimenDestination = DestinationNever
  typealias ModalDestination = DestinationNever
  typealias StackDestination = MultiChildFlowPathADestination

  func initialContent() -> some View {
    Container(
      coordinator: self
    ) { [unowned self] in
      MultiChildFlowPathAInitialScreen(
        onProceed: { [unowned self] in
          Task(operation: proceedToFinishFlow)
        }
      )
    }
  }

  @ViewBuilder
  func content(forStack destination: StackDestination) -> some View {
    switch destination {
    case .finish:
      MultiChildFlowFinishScreen(
        onDone: { [unowned self] in
          Task(operation: finishFlow)
        }
      )
    }
  }
  
  // MARK: - Logic

  func proceedToFinishFlow() async {
    await push(.finish)
  }
  
  func finishFlow() async {
    await handleChildEvent(MultiChildFlowPathAFinishEvent())
  }
  
  // MARK: - Deeplink
  
  override func processDeeplink(
    _ deeplink: any DeeplinkEventType
  ) async -> ProcessDeeplinkResult {
    #warning("TODO: Ensure coordinator is in the correct state prior to firing navigation logic")
    switch deeplink {
    case Deeplink.showMultiChildPathA:
      print("Deeplink.showMultiChildPathA: DONE")
      return .done
      
    case Deeplink.showMultiChildPathAFinish:
      await proceedToFinishFlow()
      return .done
      
    default:
      return .impossible
    }
  }
}

struct MultiChildFlowPathAFinishEvent: ChildEventType { }
