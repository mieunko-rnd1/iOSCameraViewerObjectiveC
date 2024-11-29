#ifndef CameraWrapper_hpp
#define CameraWrapper_hpp

class CameraWrapper
{
public:
	CameraWrapper();
	virtual ~CameraWrapper();
	
	bool connect();
	bool isConnected();
	bool disconnect();
	bool startStreaming();
	bool stopStreaming();
	bool isStreaming();
};
#endif // CameraWrapper_hpp
