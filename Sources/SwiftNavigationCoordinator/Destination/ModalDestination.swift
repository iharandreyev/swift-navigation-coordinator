//
//  ModalDestination.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

import CasePaths

@CasePathable
public enum ModalDestination<DestinationType: Sendable & Hashable & Identifiable>: Sendable, Hashable {
  case cover(DestinationType)
  case sheet(DestinationType)
}
