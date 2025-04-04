//
//  PerformWithoutAnimations.swift
//  swift-navigation-coordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@MainActor
func withoutAnimations(
  perform job: @MainActor @escaping () -> Void
) {
  #if os(iOS)
    withoutAnimations_iOS(perform: job)
  #else
    fatalError("Current platform is not yet supported!")
  #endif
}
