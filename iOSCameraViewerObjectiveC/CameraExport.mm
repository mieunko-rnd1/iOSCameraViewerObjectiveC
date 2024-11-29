#include "CameraExport.hpp"
#include "CameraWrapper.hpp"

CameraWrapper* wrapper = nullptr;

@implementation CameraExport

- (bool) connect
{
	if (wrapper == nullptr)
	{
		wrapper = new CameraWrapper();
	}
	
	if (wrapper != nullptr)
	{
		if (wrapper->connect())
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
	if (wrapper != nullptr)
	{
		if (wrapper->disconnect() == false)
		{
			// return false;
		}
		
		delete wrapper;
		wrapper = nullptr;
	}
	
	return true;
}

- (bool) startStreaming
{
	if (wrapper != nullptr)
	{
		if (wrapper->startStreaming())
		{
			return true;
		}
	}
	
	return false;
}

- (bool) stopStreaming
{
	if (wrapper != nullptr)
	{
		if (wrapper->stopStreaming())
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

@end // CameraExport
