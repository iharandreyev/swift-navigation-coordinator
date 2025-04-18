//
//  UsecasesList.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct UsecasesListScreen: View {
  let onShowModalSheet: () -> Void
  let onShowModalCover: () -> Void
  let onShowPushedScreen: () -> Void
  let onShowMultiChildFlow: () -> Void
  
  var body: some View {
    List {
      ListItemButton(
        title: "Show modal sheet",
        onTap: onShowModalSheet
      )
      
      ListItemButton(
        title: "Show modal cover",
        onTap: onShowModalCover
      )
      
      ListItemButton(
        title: "Show pushed screen",
        onTap: onShowPushedScreen
      )
      
      ListItemButton(
        title: "Show multi child flow",
        onTap: onShowMultiChildFlow
      )
    }
  }
}

#Preview {
  UsecasesListScreen(
    onShowModalSheet: {},
    onShowModalCover: {},
    onShowPushedScreen: {},
    onShowMultiChildFlow: {}
  )
}
