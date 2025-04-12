//
//  Optinal+CompactMap.swift
//  SampleApp_iOS
//
//  Created by Andreyeu, Ihar on 4/1/25.
//

extension Optional {
  func compactMap<T>(_ transform: (Wrapped) -> T?) -> T? {
    switch self {
    case .none: return .none
    case let .some(value): return transform(value)
    }
  }
}
