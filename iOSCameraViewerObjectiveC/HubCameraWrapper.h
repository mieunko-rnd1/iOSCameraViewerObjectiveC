#ifndef HubCameraWrapper_h
#define HubCameraWrapper_h

#include "CameraTypes.h"
#include "CameraHelper.h"

class HubCameraWrapper
{
public:
	HubCameraWrapper() = default;
	~HubCameraWrapper() = default;
	
	bool connect();
	bool isConnected();
	void disconnect();
	bool startStreaming();
	bool stopStreaming();
	bool isStreaming();
	
	void setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback);
	
private:
	bool streaming_ = false;
	
	// Test code
	void runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer);
};
#endif // HubCameraWrapper_h
