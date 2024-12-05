#include "CameraManager.hpp"

#include "CameraController.hpp"
#include "CameraControllerDelegate.h"


CameraController* controller = nil;

@interface CameraDelegate : NSObject <CameraControllerDelegate>

@property (nonatomic) ImageBuffer* imageBuffer;
@property (nonatomic) bool isConnected;

@end // CameraDelegate

@implementation CameraDelegate

- (bool)activateDelegate {
	if (controller != nil) {
		controller.cameraControllerDelegate = self;
		
		self.imageBuffer = new ImageBuffer;
		self.isConnected = true;
		
		return true;
	}
	
	return false;
}

- (void)deactivateDelegate {
	self.isConnected = false;
	
	if (self.imageBuffer) {
		delete[] self.imageBuffer;
		self.imageBuffer = nullptr;
	}
}

- (bool)getRawImageBuffer:(ImageBuffer&)imageBuffer {
	if (self.isConnected == false)
		return false;
	
	if (self.imageBuffer == nullptr)
		return false;
	
	imageBuffer = *self.imageBuffer;
	
	return true;
}

- (void)captureImageOutput:(unsigned char*)image width:(size_t)width height:(size_t)height bufferSize:(size_t)bufferSize bytesPerRow:(size_t)bytesPerRow {
	self.imageBuffer->setBuffer(image, width, height, bufferSize, bytesPerRow);
	
	NSLog(@"%02X, %02X", image[0], image[1]);
	NSLog(@"bytesPerRow: %zu, bufferWidth: %zu, bufferHeight: %zu, bufferSize: %zu", bytesPerRow, width, height, bufferSize);
}

@end // CameraDelegate


CameraDelegate* camDelegate = nil;

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
	
	if (camDelegate == nil)
		camDelegate = [[CameraDelegate alloc] init];
	
	if (controller != nil)
	{
		if ([controller connect])
		{
			if (camDelegate != nil)
			{
				if ([camDelegate activateDelegate]) {
					return true;
				}
			}
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
	[camDelegate deactivateDelegate];
	
	if (camDelegate != nil) {
		[camDelegate release];
		camDelegate = nil;
	}
	
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
