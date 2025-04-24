//
//  MultiChildFlowPathACoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowPathADestination: DestinationType {
  case finish
}

final class MultiChildFlowPathACoordinator: CoordinatorBase, StackCoordinatorType, ScreenCoordinatorType {
  typealias DestinationType = MultiChildFlowPathADestination
  
  let navigator: StackNavigator<DestinationType>
  
  init(
    navigator: StackNavigator<DestinationType>,
    onFinish: Callback<Void>? = nil
  ) {
    self.navigator = navigator
    
    super.init(onFinish: onFinish)
  }

  func initialScreen() -> some View {
    MultiChildFlowPathAInitialScreen(
      onProceed: { [unowned self] in
        Task(operation: proceedToFinishFlow)
      }
    )
    .onRemoveFromHierarchy(finish: self)
  }
  
  func screen(for destination: DestinationType) -> some View {
    switch destination {
    case .finish:
      MultiChildFlowFinishScreen(
        onDone: { [unowned self] in
          Task(operation: finishFlow)
        }
      )
    }
  }
  
  func proceedToFinishFlow() async {
    await navigator.push(.finish)
  }
  
  func finishFlow() async {
    await handleChildEvent(MultiChildFlowPathAFinishEvent())
  }
  
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
