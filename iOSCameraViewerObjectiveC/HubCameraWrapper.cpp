#include "HubCameraWrapper.h"
#include "HubCameraManager.h"

#include <cstdio>

HubCameraManager* manager = nullptr;

bool HubCameraWrapper::connect()
{
	if (manager == nullptr)
	{
		manager = new HubCameraManager();
	}
	
	if (manager != nullptr)
	{
		if (manager->connect())
		{
			// Test code
			// setImageCallback(std::bind(&CameraExport::runImageCallback, this, std::placeholders::_1));
			return true;
		}
	}
	
	return false;
}

bool HubCameraWrapper::isConnected()
{
	return true;
}

void HubCameraWrapper::disconnect()
{
	if (manager != nullptr)
	{
		manager->disconnect();
		
		delete manager;
		manager = nullptr;
	}
}

bool HubCameraWrapper::startStreaming()
{
	if (manager != nullptr)
	{
		if (manager->startStreaming())
		{
			streaming_ = true;
			return true;
		}
	}
	
	return false;
}

bool HubCameraWrapper::stopStreaming()
{
	streaming_ = false;
	
	if (manager != nullptr)
	{
		if (manager->stopStreaming())
		{
			return true;
		}
	}
	
	return false;
}

bool HubCameraWrapper::isStreaming()
{
	return streaming_;
}

void HubCameraWrapper::setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback)
{
	if ((manager == nullptr) || (callback == nullptr))
		return;
	
	manager->setImageCallback(callback);
}

// Test code
void HubCameraWrapper::runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer)
{
	printf("buffer: %02X, %02X", imageBuffer->buffer_[0], imageBuffer->buffer_[1]);
	printf("bufferWidth: %d, bufferHeight: %d, bufferSize: %d, bytesPerRow: %d, imageCount: %d",
		  imageBuffer->width_, imageBuffer->height_, imageBuffer->bufferSize_, imageBuffer->bytesPerRow_, imageBuffer->imageCount_);
}
