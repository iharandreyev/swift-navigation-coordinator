//
//  InfoLastScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct InfoLastScreen: View {
  let onDone: () -> Void
  
  var body: some View {
    VStack(spacing: 32) {
      Text(
      """
        This is last `info` screen\n
        It shows a node screen within a stack
      """
      )
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      Button(
        "Done",
        action: onDone
      )
    }
    .padding()
  }
}

#Preview {
  InfoLastScreen(
    onDone: {}
  )
}
