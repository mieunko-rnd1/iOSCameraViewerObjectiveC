#include "CameraWrapper.h"
#include "CameraManager.h"

#include <cstdio>

CameraManager* manager = nullptr;

bool CameraWrapper::connect()
{
	if (manager == nullptr)
	{
		manager = new CameraManager();
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

bool CameraWrapper::isConnected()
{
	return true;
}

bool CameraWrapper::disconnect()
{
	if (manager != nullptr)
	{
		if (manager->disconnect() == false)
		{
			// return false;
		}
		
		delete manager;
		manager = nullptr;
	}
	
	return true;
}

bool CameraWrapper::startStreaming()
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

bool CameraWrapper::stopStreaming()
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

bool CameraWrapper::isStreaming()
{
	return streaming_;
}

void CameraWrapper::setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback)
{
	if ((manager == nullptr) || (callback == nullptr))
		return;
	
	manager->setImageCallback(callback);
}

// Test code
void CameraWrapper::runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer)
{
	printf("buffer: %02X, %02X", imageBuffer->buffer_[0], imageBuffer->buffer_[1]);
	printf("bufferWidth: %d, bufferHeight: %d, bufferSize: %d, bytesPerRow: %d, imageCount: %d",
		  imageBuffer->width_, imageBuffer->height_, imageBuffer->bufferSize_, imageBuffer->bytesPerRow_, imageBuffer->imageCount_);
}
