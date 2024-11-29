// Camera 접근 권한 설정, https://adjh54.tistory.com/126
// Target -> Build Settings -> Privacy - Camera Usage Description -> 카메라 접근을 허용해주세요

// Metal API Validation 끄기, https://forums.developer.apple.com/forums/thread/710843
// Product -> Scheme -> Edit Scheme -> Run -> Diagnostics -> Metal API Validation

// C++ / Objective-C Interop 가능하게 하기, https://forums.developer.apple.com/forums/thread/740529
// Target -> Build Settings -> Swift Compiler - Language -> C++ and Objective-C Interoperability -> C++ / Objective-C

// [obj release] 안될 경우,
// https://stackoverflow.com/questions/22996437/release-is-unavailable-not-available-in-automatic-reference-counting-mode
// Target -> Build Settings -> Objective-C Automatic Reference Counting -> No

import SwiftUI

@main
struct iOSCameraViewerObjectiveCApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
