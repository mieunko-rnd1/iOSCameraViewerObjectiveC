#ifndef CameraHelper_h
#define CameraHelper_h

#include "CameraTypes.h"

#include <functional>

namespace Camera
{
class ImageCallbacks
{
public:
	static std::function<void(std::shared_ptr<ImageBuffer>)> callback_;
	static void updateImageCallback(std::shared_ptr<ImageBuffer>);
};
}

#endif // CameraHelper_h
