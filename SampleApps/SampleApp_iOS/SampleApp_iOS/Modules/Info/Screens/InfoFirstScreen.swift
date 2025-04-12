//
//  InfoFirstScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct InfoFirstScreen: View {
  let onContinue: () -> Void
  
  var body: some View {
    VStack(spacing: 32) {
      Text(
      """
        This is first `info` screen\n
        It shows a root screen within a stack
      """
      )
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      Button(
        "Continue",
        action: onContinue
      )
    }
    .padding()
  }
}

#Preview {
  InfoFirstScreen(
    onContinue: {}
  )
}
