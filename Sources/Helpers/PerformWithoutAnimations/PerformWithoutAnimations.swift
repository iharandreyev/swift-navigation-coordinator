//
//  PerformWithoutAnimations.swift
//  SUINavigationCoordinator
//
//  Created by Andreyeu, Ihar on 3/26/25.
//

#warning("TODO: Extend support to WatchOS, macOS and TvOS")
@MainActor
func withoutAnimations(
  perform job: @MainActor @escaping () -> Void
) {
  if #available(iOS 16, *) {
    withoutAnimations_iOS(perform: job)
  } else {
    fatalError("Not implemented")
  }
}
