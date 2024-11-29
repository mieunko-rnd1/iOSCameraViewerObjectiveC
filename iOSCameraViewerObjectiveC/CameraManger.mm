#include "CameraManager.hpp"
#include "CameraController.hpp"

CameraController* controller = nil;

CameraManager::CameraManager()
{
	
}

CameraManager::~CameraManager()
{
	
}

bool CameraManager::connect()
{
	if (controller == nil)
		controller = [[CameraController alloc] init];
		//controller = [CameraController new];
	
	if (controller != nil)
	{
		if ([controller connect])
		{
			return true;
		}
	}
	
	return false;
}

bool CameraManager::isConnected()
{
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

bool CameraManager::startStreaming()
{
	if (controller != nil)
	{
		if ([controller startStreaming])
		{
			return true;
		}
	}
	
	return false;
}

bool CameraManager::stopStreaming()
{
	if (controller != nil)
	{
		if ([controller stopStreaming])
		{
			return true;
		}
	}
	
	return false;
}

bool CameraManager::isStreaming()
{
	return true;
}
