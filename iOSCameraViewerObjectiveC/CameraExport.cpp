#include "CameraExport.hpp"

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
		return manager->startStreaming();
	}
	
	return false;
}

bool CameraExport::stopStreaming()
{
	if (manager != nullptr)
	{
		return manager->stopStreaming();
	}
	
	return false;
}

bool CameraExport::isStreaming()
{
	return true;
}
