#ifndef CameraExport_hpp
#define CameraExport_hpp

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
};
#endif // CameraExport_hpp
