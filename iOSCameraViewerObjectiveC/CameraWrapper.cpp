#include "CameraWrapper.hpp"
#include "CameraManager.hpp"

CameraManager* manager = nullptr;

CameraWrapper::CameraWrapper()
{
	
}

CameraWrapper::~CameraWrapper()
{
	
}

bool CameraWrapper::connect()
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
		return manager->startStreaming();
	}
	
	return false;
}

bool CameraWrapper::stopStreaming()
{
	if (manager != nullptr)
	{
		return manager->stopStreaming();
	}
	
	return false;
}

bool CameraWrapper::isStreaming()
{
	return true;
}
