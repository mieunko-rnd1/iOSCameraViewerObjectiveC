#include "CameraModule.h"
#include "CameraWrapper.h"

CameraWrapper* cameraWrapper = nullptr;

@implementation CameraModule

- (bool) connect {
	if (cameraWrapper == nullptr) {
		cameraWrapper = new CameraWrapper();
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

- (bool) disconnect {
	if (cameraWrapper != nullptr) {
		if (cameraWrapper->disconnect() == false) {
			// return false;
		}
		
		delete cameraWrapper;
		cameraWrapper = nullptr;
	}
	
	return true;
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
