//
//  MultiChildFlowFinishScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowFinishScreen: View {
  let onDone: () -> Void
  
  var body: some View {
    VStack {
      Text("Flow finished!")
      
      Button("Done", action: onDone)
    }
  }
}
