//
//  LogMessageType.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

protocol LogMessageType: CustomStringConvertible {
  var content: String { get }
  
  init(content: String)
}
