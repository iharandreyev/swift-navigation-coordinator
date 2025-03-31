//
//  LogMessageWarning.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

struct LogMessageWarning: LogMessageType {
  let content: String
  
  var description: String {
    "📙 WARNING: \(content)."
  }
}
