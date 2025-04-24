//
//  MultiChildFlowPathBInitialScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowPathBInitialScreen: View {
  let onProceed: () -> Void
  
  var body: some View {
    VStack {
      Text("Path B")
      
      Button(
        "Proceed",
        action: onProceed
      )
    }
  }
}
