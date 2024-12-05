#include "CameraHelper.h"

#include <iostream>

namespace Camera
{
std::function<void(unsigned int)> ImageCallbacks::callback_ = nullptr;

void ImageCallbacks::setCameraImageCallback(std::function<void(unsigned int)> callback)
{
	if (ImageCallbacks::callback_)
		return ImageCallbacks::callback_(value);
}

void ImageCallbacks::captureImageOutput(unsigned int value)
{
	/*
	if (onCaptureImageOutput)
	{
		onCaptureImageOutput();
	}
	else
	{
		std::cout << "Capture image output connected." << std::endl;
	}
	*/
}
