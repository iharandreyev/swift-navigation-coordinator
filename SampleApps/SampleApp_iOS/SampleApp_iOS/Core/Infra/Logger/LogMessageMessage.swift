//
//  LogMessage.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

struct LogMessageMessage: LogMessageType {
  let content: String
  
  var description: String {
    "📘 \(content)."
  }
}
