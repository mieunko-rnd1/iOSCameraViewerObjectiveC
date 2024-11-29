#ifndef CameraManager_hpp
#define CameraManager_hpp

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
	bool isStreaming();
};

#endif // CameraManager_hpp
