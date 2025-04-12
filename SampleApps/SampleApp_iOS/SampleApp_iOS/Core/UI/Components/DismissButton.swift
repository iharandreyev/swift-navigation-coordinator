//
//  DismissButton.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct DismissButton: View {
  @Environment(\.dismiss)
  private var dismiss
  
  private let label: String
  
  init(label: String = "Dismiss") {
    self.label = label
  }
  
  var body: some View {
    Button(
      label,
      action: {
        dismiss()
      }
    )
  }
}
