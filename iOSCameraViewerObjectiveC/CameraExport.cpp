#include "CameraExport.h"
#include "CameraManager.hpp"

CameraManager* manager = nullptr;

CameraExport::CameraExport()
{
	
}

CameraExport::~CameraExport()
{
	
}

bool CameraExport::connect()
{
	if (manager == nullptr)
	{
		manager = new CameraManager();
	}
	
	if (manager != nullptr)
	{
		return manager->connect();
	}
	
	return false;
}

bool CameraExport::isConnected()
{
	return true;
}

bool CameraExport::disconnect()
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

bool CameraExport::startStreaming()
{
	if (manager != nullptr)
	{
		/*
		if (manager->setCameraImageCallback(callback) == false)
		{
			return false;
		}
		*/
		if (manager->startStreaming())
		{
			streaming_ = true;
			return true;
		}
	}
	
	return false;
}

bool CameraExport::stopStreaming()
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

bool CameraExport::isStreaming()
{
	return streaming_;
}
