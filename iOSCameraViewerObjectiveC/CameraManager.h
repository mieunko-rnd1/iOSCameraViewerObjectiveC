#ifndef CameraManager_h
#define CameraManager_h

#include "CameraTypes.h"
#include "CameraHelper.h"

#include <functional>

class CameraManager
{
public:
	CameraManager() = default;
	~CameraManager() = default;
	
	bool connect();
	bool isConnected();
	bool disconnect();
	bool startStreaming();
	bool stopStreaming();
	
	void setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback);
	
private:
	// Test code
	void runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer);
};

#endif // CameraManager_h
