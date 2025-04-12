//
//  MultiChildFlowConfirmRestartScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowConfirmRestartScreen: View {
  let onRestart: () -> Void
  
  var body: some View {
    VStack {
      Text("Confirm Restart")
      
      Button("Restart", action: onRestart)
    }
  }
}
