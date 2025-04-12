//
//  MultiChildFlowSelectPathScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowSelectPathScreen: View {
  let onPathA: () -> Void
  let onPathB: () -> Void
  let onRestart: () -> Void
  
  var body: some View {
    List {
      ListItemButton(title: "Show path A", onTap: onPathA)
      ListItemButton(title: "Show path B", onTap: onPathB)
      ListItemButton(title: "Restart", onTap: onRestart)
    }
  }
}
