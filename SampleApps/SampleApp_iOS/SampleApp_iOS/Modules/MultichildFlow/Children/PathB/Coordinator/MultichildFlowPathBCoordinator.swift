//
//  MultiChildFlowPathBCoordinator.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftNavigationCoordinator
import SwiftUI

enum MultiChildFlowPathBDestination: String, ModalDestinationContentType {
  case finish
  
  var id: String {
    rawValue
  }
}

final class MultiChildFlowPathBCoordinator: CoordinatorBase, ModalCoordinatorType, ScreenCoordinatorType {
  typealias DestinationType = MultiChildFlowPathBDestination
  
  let modalNavigator: ModalNavigator<DestinationType>
  
  init(
    modalNavigator: ModalNavigator<DestinationType>,
    onFinish: Callback<Void>? = nil
  ) {
    self.modalNavigator = modalNavigator
    
    super.init(onFinish: onFinish)
  }

  func initialScreen() -> some View {
    MultiChildFlowPathBInitialScreen(
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
    await modalNavigator.presentDestination(.cover(.finish))
  }
  
  func finishFlow() async {
    await handleChildEvent(MultiChildFlowPathBFinishEvent())
  }
}

struct MultiChildFlowPathBFinishEvent: ChildEventType { }
