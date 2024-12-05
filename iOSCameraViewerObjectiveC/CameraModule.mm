#import "CameraModule.hpp"

#include "CameraExport.hpp"

CameraExport* cameraExport = nullptr;

@implementation CameraModule

- (bool) connect
{
	if (cameraExport == nullptr)
	{
		cameraExport = new CameraExport();
	}
	
	if (cameraExport != nullptr)
	{
		if (cameraExport->connect())
		{
			return true;
		}
	}
	
	return false;
}

- (bool) isConnected
{
	return true;
}

- (bool) disconnect
{
	if (cameraExport != nullptr)
	{
		if (cameraExport->disconnect() == false)
		{
			// return false;
		}
		
		delete cameraExport;
		cameraExport = nullptr;
	}
	
	return true;
}

- (bool) startStreaming
{
	if (cameraExport != nullptr)
	{
		if (cameraExport->startStreaming())
		{
			return true;
		}
	}
	
	return false;
}

- (bool) stopStreaming
{
	if (cameraExport != nullptr)
	{
		if (cameraExport->stopStreaming())
		{
			return true;
		}
	}
	
	return false;
}

- (bool) isStreaming
{
	return true;
}

@end // CameraModule
