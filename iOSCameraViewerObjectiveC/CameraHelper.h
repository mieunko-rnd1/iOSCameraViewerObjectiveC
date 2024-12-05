#ifndef CameraHelper_h
#define CameraHelper_h

#include <functional>

namespace Camera
{
typedef void(*CameraImageCallback)();

class ImageCallbacks
{
public:
	static void setCameraImageCallback(std::function<void(unsigned int)> callback);
	static void captureImageOutput(unsigned int value);
	
private:
	static std::function<void(unsigned int)> callback_;
};
}

#endif // CameraHelper_h
