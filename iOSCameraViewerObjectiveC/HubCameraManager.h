#ifndef HubCameraManager_h
#define HubCameraManager_h

#include "CameraTypes.h"
#include "CameraHelper.h"

#include <functional>

class HubCameraManager
{
public:
	HubCameraManager() = default;
	~HubCameraManager() = default;
	
	bool connect();
	bool isConnected();
	void disconnect();
	bool startStreaming();
	bool stopStreaming();
	
	void setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback);
	
private:
	// Test code
	void runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer);
};

#endif // HubCameraManager_h
