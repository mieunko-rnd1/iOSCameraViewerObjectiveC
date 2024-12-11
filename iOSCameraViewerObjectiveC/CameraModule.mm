#include "CameraModule.h"
#include "HubCameraWrapper.h"

HubCameraWrapper* cameraWrapper = nullptr;

@implementation CameraModule

- (bool) connect {
	if (cameraWrapper == nullptr) {
		cameraWrapper = new HubCameraWrapper();
	}
	
	if (cameraWrapper != nullptr) {
		if (cameraWrapper->connect()) {
			return true;
		}
	}
	
	return false;
}

- (bool) isConnected {
	return true;
}

- (void) disconnect {
	if (cameraWrapper != nullptr) {
		cameraWrapper->disconnect();
		
		delete cameraWrapper;
		cameraWrapper = nullptr;
	}
}

- (bool) startStreaming {
	if (cameraWrapper != nullptr) {
		if (cameraWrapper->startStreaming()) {
			return true;
		}
	}
	
	return false;
}

- (bool) stopStreaming {
	if (cameraWrapper != nullptr) {
		if (cameraWrapper->stopStreaming()) {
			return true;
		}
	}
	
	return false;
}

- (bool) isStreaming {
	return true;
}

@end // CameraModule
