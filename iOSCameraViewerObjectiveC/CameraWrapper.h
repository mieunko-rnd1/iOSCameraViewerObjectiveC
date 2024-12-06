#ifndef CameraWrapper_h
#define CameraWrapper_h

#include "CameraTypes.h"
#include "CameraHelper.h"

class CameraWrapper
{
public:
	CameraWrapper() = default;
	~CameraWrapper() = default;
	
	bool connect();
	bool isConnected();
	bool disconnect();
	bool startStreaming();
	bool stopStreaming();
	bool isStreaming();
	
	void setImageCallback(std::function<void(std::shared_ptr<ImageBuffer>)> callback);
	
private:
	bool streaming_ = false;
	
	// Test code
	void runImageCallback(std::shared_ptr<ImageBuffer> imageBuffer);
};
#endif // CameraWrapper_h
