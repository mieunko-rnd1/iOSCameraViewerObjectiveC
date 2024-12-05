#ifndef CameraExport_hpp
#define CameraExport_hpp

#include "CameraTypes.h"

class CameraExport
{
public:
	CameraExport();
	virtual ~CameraExport();
	
	bool connect();
	bool isConnected();
	bool disconnect();
	bool startStreaming();
	bool stopStreaming();
	bool isStreaming();
	
private:
	bool streaming_ = false;
};
#endif // CameraExport_hpp
