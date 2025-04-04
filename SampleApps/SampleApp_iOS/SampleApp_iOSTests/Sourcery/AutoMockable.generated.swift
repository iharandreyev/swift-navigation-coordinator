// Generated using Sourcery 2.2.6 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import SwiftUI
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import SwiftNavigationCoordinator

@testable import SampleApp_iOS
























final class AppCoordinatorFactoryDelegateTypeMock<
    AppInitScreenType: View,
    MainCoordinatorType: StaticSpecimenCoordinatorType & LabelledSpecimenCoordinatorType,
    OnboardingCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType>: AppCoordinatorFactoryDelegateType {




    //MARK: - createAppInitScreen

    var createAppInitScreenOnFinishCallbackVoidCallsCount = 0
    var createAppInitScreenOnFinishCallbackVoidCalled: Bool {
        return createAppInitScreenOnFinishCallbackVoidCallsCount > 0
    }
    var createAppInitScreenOnFinishCallbackVoidReceivedOnFinish: (Callback<Void>)?
    var createAppInitScreenOnFinishCallbackVoidReceivedInvocations: [(Callback<Void>)] = []
    var createAppInitScreenOnFinishCallbackVoidReturnValue: AppInitScreenType!
    var createAppInitScreenOnFinishCallbackVoidClosure: ((Callback<Void>) -> AppInitScreenType)?

    func createAppInitScreen(onFinish: Callback<Void>) -> AppInitScreenType {
        createAppInitScreenOnFinishCallbackVoidCallsCount += 1
        createAppInitScreenOnFinishCallbackVoidReceivedOnFinish = onFinish
        createAppInitScreenOnFinishCallbackVoidReceivedInvocations.append(onFinish)
        if let createAppInitScreenOnFinishCallbackVoidClosure = createAppInitScreenOnFinishCallbackVoidClosure {
            return createAppInitScreenOnFinishCallbackVoidClosure(onFinish)
        } else {
            return createAppInitScreenOnFinishCallbackVoidReturnValue
        }
    }

    //MARK: - createOnboardingCoordinator

    var createOnboardingCoordinatorOnFinishCallbackVoidCallsCount = 0
    var createOnboardingCoordinatorOnFinishCallbackVoidCalled: Bool {
        return createOnboardingCoordinatorOnFinishCallbackVoidCallsCount > 0
    }
    var createOnboardingCoordinatorOnFinishCallbackVoidReceivedOnFinish: (Callback<Void>)?
    var createOnboardingCoordinatorOnFinishCallbackVoidReceivedInvocations: [(Callback<Void>)] = []
    var createOnboardingCoordinatorOnFinishCallbackVoidReturnValue: OnboardingCoordinatorType!
    var createOnboardingCoordinatorOnFinishCallbackVoidClosure: ((Callback<Void>) -> OnboardingCoordinatorType)?

    func createOnboardingCoordinator(onFinish: Callback<Void>) -> OnboardingCoordinatorType {
        createOnboardingCoordinatorOnFinishCallbackVoidCallsCount += 1
        createOnboardingCoordinatorOnFinishCallbackVoidReceivedOnFinish = onFinish
        createOnboardingCoordinatorOnFinishCallbackVoidReceivedInvocations.append(onFinish)
        if let createOnboardingCoordinatorOnFinishCallbackVoidClosure = createOnboardingCoordinatorOnFinishCallbackVoidClosure {
            return createOnboardingCoordinatorOnFinishCallbackVoidClosure(onFinish)
        } else {
            return createOnboardingCoordinatorOnFinishCallbackVoidReturnValue
        }
    }

    //MARK: - createMainCoordinator

    var createMainCoordinatorCallsCount = 0
    var createMainCoordinatorCalled: Bool {
        return createMainCoordinatorCallsCount > 0
    }
    var createMainCoordinatorReturnValue: MainCoordinatorType!
    var createMainCoordinatorClosure: (() -> MainCoordinatorType)?

    func createMainCoordinator() -> MainCoordinatorType {
        createMainCoordinatorCallsCount += 1
        if let createMainCoordinatorClosure = createMainCoordinatorClosure {
            return createMainCoordinatorClosure()
        } else {
            return createMainCoordinatorReturnValue
        }
    }


}
final class MainCoordinatorFactoryDelegateTypeMock<
    DeeplinksCoordinatorType: ScreenCoordinatorType,
    UsecasesCoordinatorType: ScreenCoordinatorType & StackCoordinatorType & ModalCoordinatorType>: MainCoordinatorFactoryDelegateType {




    //MARK: - createUsecasesCoordinator

    var createUsecasesCoordinatorCallsCount = 0
    var createUsecasesCoordinatorCalled: Bool {
        return createUsecasesCoordinatorCallsCount > 0
    }
    var createUsecasesCoordinatorReturnValue: UsecasesCoordinatorType!
    var createUsecasesCoordinatorClosure: (() -> UsecasesCoordinatorType)?

    func createUsecasesCoordinator() -> UsecasesCoordinatorType {
        createUsecasesCoordinatorCallsCount += 1
        if let createUsecasesCoordinatorClosure = createUsecasesCoordinatorClosure {
            return createUsecasesCoordinatorClosure()
        } else {
            return createUsecasesCoordinatorReturnValue
        }
    }

    //MARK: - createDeeplinksCoordinator

    var createDeeplinksCoordinatorCallsCount = 0
    var createDeeplinksCoordinatorCalled: Bool {
        return createDeeplinksCoordinatorCallsCount > 0
    }
    var createDeeplinksCoordinatorReturnValue: DeeplinksCoordinatorType!
    var createDeeplinksCoordinatorClosure: (() -> DeeplinksCoordinatorType)?

    func createDeeplinksCoordinator() -> DeeplinksCoordinatorType {
        createDeeplinksCoordinatorCallsCount += 1
        if let createDeeplinksCoordinatorClosure = createDeeplinksCoordinatorClosure {
            return createDeeplinksCoordinatorClosure()
        } else {
            return createDeeplinksCoordinatorReturnValue
        }
    }


}
