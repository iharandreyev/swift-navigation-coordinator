//
//  AppInitScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct AppInitScreen: View {
  private(set) var onFinish: () -> Void
  
  var body: some View {
    VStack(spacing: 32) {
      Text(
      """
        This is app init screen\n
        It shows some loading animation 
        while the app is fetching all the necessary data
        to start successfully
      """
      )
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      ProgressView()
    }
    .padding()
    .onAppear(perform: simulateInit)
  }
  
  private func simulateInit() {
    Task.detached {
      try await Task.sleep(for: .seconds(2))
      
      await Task.detached { @MainActor in
        onFinish()
      }
      .value
    }
  }
}

#Preview {
  AppInitScreen(onFinish: {})
}
