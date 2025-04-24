//
//  MultiChildFlowPathAInitialScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowPathAInitialScreen: View {
  let onProceed: () -> Void
  
  var body: some View {
    VStack {
      Text("Path A")
      
      Button(
        "Proceed",
        action: onProceed
      )
    }
  }
}
