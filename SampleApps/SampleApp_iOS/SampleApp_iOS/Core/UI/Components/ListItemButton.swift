//
//  ListItemButton.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

import SwiftUI

struct ListItemButton: View {
  let title: String
  let onTap: () -> Void
  
  var body: some View {
    Button(
      action: onTap,
      label: {
        Text(title)
      }
    )
  }
}
