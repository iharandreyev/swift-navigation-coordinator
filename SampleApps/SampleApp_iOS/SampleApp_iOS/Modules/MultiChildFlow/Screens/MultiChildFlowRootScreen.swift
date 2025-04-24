//
//  MultiChildFlowRootScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct MultiChildFlowRootScreen: View {
  let onNext: () -> Void
  
  var body: some View {
    VStack {
      Text("Some root screen")
      
      Button("Next", action: onNext)
    }
  }
}
