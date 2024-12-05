#ifndef CameraManager_hpp
#define CameraManager_hpp

#include "CameraTypes.h"
#include "CameraHelper.h"

#include <functional>
#include <thread>

class ImageCallbackWrapper
{
public:
	static std::function<void(Camera::CameraImageCallback*)> callback_;
	static void imageCallback(Camera::CameraImageCallback* callback);
};

class CameraManager
{
public:
	CameraManager();
	virtual ~CameraManager();
	
	bool connect();
	bool isConnected();
	bool disconnect();
	bool startStreaming();
	bool stopStreaming();
	
	//bool setCameraImageCallback(std::function<void(ImageBuffer* imageBuffer)> callback);
	void setImageCallback(std::function<void(Camera::CameraImageCallback* callback)> callback);
	//void setImageCallback(void (*callback)());
	void imageCallback();
	void receiveImageCallback(Camera::CameraImageCallback* callback);
	/*
	void startCaptureThread();
	void stopCaptureThread();
	void closeCaptureThread();
	void captureThread();
	
	std::thread captureThread_;
	std::atomic_bool runningCaptureThread_ = { false };
	*/
private:
	std::function<void(Camera::CameraImageCallback* callback)> onCaptureImageOutput;
};

#endif // CameraManager_hpp
