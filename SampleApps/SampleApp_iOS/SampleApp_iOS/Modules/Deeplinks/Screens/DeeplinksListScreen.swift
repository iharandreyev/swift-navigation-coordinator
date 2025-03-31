//
//  DeeplinksListScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct DeeplinksListScreen: View {
  @Environment(\.urlOpener)
  private var urlOpener
  
  var body: some View {
    List {
      ForEach(Deeplink.allCases, id: \.rawValue) {
        DeeplinkItemView(deeplink: $0) { deeplink in
          urlOpener.openURL(DeeplinkURLFactory.createURL(for: deeplink))
        }
      }
    }
  }
}

struct DeeplinkItemView: View {
  let deeplink: Deeplink
  let onTap: (Deeplink) -> Void
  
  var body: some View {
    ListItemButton(
      title: deeplink.rawValue,
      onTap: {
        onTap(deeplink)
      }
    )
  }
}

#Preview {
  DeeplinksListScreen()
}
