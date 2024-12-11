#include "HubCameraManager.h"
#include "HubCameraController.h"

HubCameraController* controller = nil;

bool HubCameraManager::connect() {
	if (controller == nil)
		controller = [[HubCameraController alloc] init];
	
	if (controller != nil)
	{
		if ([controller connect])
		{
			// Test code
			// setImageCallback(std::bind(&CameraManager::runImageCallback, this, std::placeholders::_1));
			return true;
		}
	}
	
	return false;
}

bool HubCameraManager::isConnected() {
	return false;
}

void HubCameraManager::disconnect()
{
	if (controller != nil)
	{
		[controller disconnect];
		
		[controller release];
		controller = nil;
	}
}

bool HubCameraManager::startStreaming() {
	if (controller != nil) {
		if ([controller startStreaming]) {
			return true;
		}
	}
	
	return false;
}

bool HubCameraManager::stopStreaming() {
	if (controller != nil) {
		if ([controller stopStreaming]) {
			return true;
		}
	}
	
	return false;
}

void HubCameraManager::setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback)
{
	if (callback == nullptr)
		return;
	
	Camera::ImageCallbacks::callback_ = std::move(callback);
}

// Test code
void HubCameraManager::runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer)
{
	NSLog(@"buffer: %02X, %02X", imageBuffer->buffer_[0], imageBuffer->buffer_[1]);
	NSLog(@"bufferWidth: %d, bufferHeight: %d, bufferSize: %d, bytesPerRow: %d, imageCount: %d",
		  imageBuffer->width_, imageBuffer->height_, imageBuffer->bufferSize_, imageBuffer->bytesPerRow_, imageBuffer->imageCount_);
}
