//
//  WithAnimations.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 4/3/25.
//

actor WithAnimations {
#if os(iOS)
  private lazy var wrapped = WithAnimations_iOS()
#else
  private lazy var wrapped = WithAnimations_unsupported()
#endif

  func run(
    _ job: @MainActor @Sendable @escaping () -> Void
  ) async  {
    await wrapped.run(job)
  }
}
