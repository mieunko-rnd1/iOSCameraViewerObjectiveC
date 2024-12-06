#include "CameraManager.h"
#include "CameraController.h"

CameraController* controller = nil;

bool CameraManager::connect() {
	if (controller == nil)
		controller = [[CameraController alloc] init];
	
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

bool CameraManager::isConnected() {
	return false;
}

bool CameraManager::disconnect()
{
	if (controller != nil)
	{
		if ([controller disconnect] == false)
		{
			//return false;
		}
		
		[controller release];
		controller = nil;
	}
	
	return true;
}

bool CameraManager::startStreaming() {
	if (controller != nil) {
		if ([controller startStreaming]) {
			return true;
		}
	}
	
	return false;
}

bool CameraManager::stopStreaming() {
	if (controller != nil) {
		if ([controller stopStreaming]) {
			return true;
		}
	}
	
	return false;
}

void CameraManager::setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback)
{
	if (callback == nullptr)
		return;
	
	Camera::ImageCallbacks::callback_ = std::move(callback);
}

// Test code
void CameraManager::runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer)
{
	NSLog(@"buffer: %02X, %02X", imageBuffer->buffer_[0], imageBuffer->buffer_[1]);
	NSLog(@"bufferWidth: %d, bufferHeight: %d, bufferSize: %d, bytesPerRow: %d, imageCount: %d",
		  imageBuffer->width_, imageBuffer->height_, imageBuffer->bufferSize_, imageBuffer->bytesPerRow_, imageBuffer->imageCount_);
}
