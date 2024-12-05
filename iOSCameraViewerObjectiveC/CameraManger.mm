#include "CameraManager.hpp"

#include "CameraController.hpp"


std::function<void(Camera::CameraImageCallback*)> ImageCallbackWrapper::callback_ = nullptr;
void ImageCallbackWrapper::imageCallback(Camera::CameraImageCallback* callback)
{
	if (ImageCallbackWrapper::callback_)
		return ImageCallbackWrapper::callback_(callback);
}

CameraController* controller = nil;

CameraManager::CameraManager() {
	
}

CameraManager::~CameraManager() {
	
}

bool CameraManager::connect() {
	if (controller == nil)
		controller = [[CameraController alloc] init];
	
	if (controller != nil)
	{
		if ([controller connect])
		{
			setImageCallback(std::bind(&CameraManager::receiveImageCallback, this, std::placeholders::_1));
			//Camera::ImageCallbacks::setCameraImageCallback(CameraManager::imageCallback);
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

void CameraManager::setImageCallback(std::function<void(Camera::CameraImageCallback* callback)> callback)
//void CameraManager::setImageCallback(void (*callback)())
{
	if (callback == nullptr)
		return;
	Camera::CameraImageCallback::setCameraImageCallback(callback);
	//onCaptureImageOutput = callback;
	//ImageCallbackWrapper::callback_ = std::move(callback);
}

void CameraManager::imageCallback()
{
	NSLog(@"CameraManager::imageCallback");
}

void CameraManager::receiveImageCallback(Camera::CameraImageCallback* callback)
{
	NSLog(@"CameraManager::receiveImageCallback");
	
	//NSLog(@"%02X, %02X", image[0], image[1]);
	//NSLog(@"bufferWidth: %zu, bufferHeight: %zu, bufferSize: %zu, bytesPerRow: %zu",
	//	  imageBuffer->getWidth(), imageBuffer->getHeight(), imageBuffer->getBufferSize(), imageBuffer->getBytesPerRow());
}
/*
void CameraManager::startCaptureThread()
{
	runningCaptureThread_.store(true);
	captureThread_ = std::thread(&CameraManager::captureThread, this);
}

void CameraManager::stopCaptureThread()
{
	runningCaptureThread_.store(false);
}

void CameraManager::closeCaptureThread()
{
	if (captureThread_.joinable())
		captureThread_.join();
}

void CameraManager::captureThread()
{
	while (runningCaptureThread_.load())
	{
		std::this_thread::sleep_for(std::chrono::milliseconds(30));
	}
}
*/
