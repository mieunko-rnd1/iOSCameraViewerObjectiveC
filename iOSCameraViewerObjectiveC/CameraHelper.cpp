#include "CameraHelper.h"

#include <iostream>

namespace Camera
{
	std::function<void(std::shared_ptr<ImageBuffer>)> ImageCallbacks::callback_ = nullptr;
	void ImageCallbacks::updateImageCallback(std::shared_ptr<ImageBuffer> imageBuffer)
	{
		if (ImageCallbacks::callback_)
			return ImageCallbacks::callback_(imageBuffer);
	}
}
