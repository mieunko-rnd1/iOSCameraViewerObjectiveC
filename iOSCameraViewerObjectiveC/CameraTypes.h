#ifndef CameraTypes_h
#define CameraTypes_h

#include <string.h>

class ImageBuffer
{
public:
	ImageBuffer(unsigned char* buffer, unsigned int width, unsigned int height, unsigned int bufferSize, unsigned int bytesPerRow, unsigned int imageCount = 1)
		: buffer_(buffer), width_(width), height_(height), bufferSize_(bufferSize), bytesPerRow_(bytesPerRow), imageCount_(imageCount)
	{
		//
	}
	
	unsigned char* buffer_ = { nullptr };
	unsigned int width_ = { 0 };
	unsigned int height_ = { 0 };
	unsigned int bufferSize_ = { 0 };
	unsigned int bytesPerRow_ = { 0 };
	unsigned int imageCount_ = { 1 };
};

#endif // CameraTypes_h
