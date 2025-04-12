//
//  SomeScreen.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/12/25.
//

import SwiftUI

struct SomeScreen<Content: View>: View {
  private let description: String
  private let content: () -> Content
  
  init(
    name: String,
    description: String? = nil,
    content: @escaping () -> Content
  ) {
    if let description {
      self.description = "This is `\(name)`\n It shows \(description)"
    } else {
      self.description = "This is `\(name)`"
    }
    
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 32) {
      Text(description)
      .lineLimit(nil)
      .multilineTextAlignment(.center)
      
      content()
    }
    .padding()
  }
}

extension SomeScreen where Content == EmptyView {
  init(
    name: String,
    description: String? = nil
  ) {
    self.init(name: name, description: description, content: EmptyView.init)
  }
}
