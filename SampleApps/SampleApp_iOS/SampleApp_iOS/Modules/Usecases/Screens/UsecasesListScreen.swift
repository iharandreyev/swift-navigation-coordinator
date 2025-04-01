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
    }
  }
}

#Preview {
  UsecasesListScreen(
    onShowModalSheet: {},
    onShowModalCover: {}
  )
}
