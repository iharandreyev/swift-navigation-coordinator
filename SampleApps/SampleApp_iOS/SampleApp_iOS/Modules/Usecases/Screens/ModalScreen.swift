//
//  ModalScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct ModalScreen: View {
  @Environment(\.dismiss)
  private var dismiss
  
  var body: some View {
    VStack(spacing: 32) {
      Text(
        "This screen is presented modally"
      )
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      Button(
        "Dismiss",
        action: {
          dismiss()
        }
      )
    }
  }
}
