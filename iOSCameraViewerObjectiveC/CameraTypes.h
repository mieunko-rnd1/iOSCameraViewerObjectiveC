#ifndef CameraTypes_h
#define CameraTypes_h

#include <string.h>

class ImageBuffer
{
public:
	ImageBuffer() = default;
	ImageBuffer(unsigned char* buffer, size_t width, size_t height, size_t bufferSize, size_t bytesPerRow)
	{
		setBuffer(buffer, width, height, bufferSize, bytesPerRow);
	}
	~ImageBuffer()
	{
		deleteBuffer();
	}
	
	void setBuffer(unsigned char* buffer, size_t width, size_t height, size_t bufferSize, size_t bytesPerRow, unsigned int imageCount = 1)
	{
		if (buffer == nullptr)
			return;
		
		if (this->buffer < buffer)
		{
			deleteBuffer();
			this->buffer = new unsigned char[bufferSize];
		}
		memcpy(this->buffer, buffer, bufferSize);
		
		this->width = width;
		this->height = height;
		this->bufferSize = bufferSize;
		this->bytesPerRow = bytesPerRow;
		this->imageCount = imageCount;
	}
	
	unsigned char* getBuffer() { return buffer; };
	size_t getWidth() { return width; };
	size_t getHeight() { return height; };
	size_t getBufferSize() { return bufferSize; };
	size_t getBytesPerRow() { return bytesPerRow; };
	size_t getImageCount() { return imageCount; };
	
private:
	void deleteBuffer()
	{
		if (buffer != nullptr)
		{
			delete[] buffer;
			buffer = nullptr;
		}
	}
	
	unsigned char* buffer = { nullptr };
	size_t width = { 0 };
	size_t height = { 0 };
	size_t bufferSize = { 0 };
	size_t bytesPerRow = { 0 };
	unsigned int imageCount = { 1 };
};

typedef void(imageCallback)(ImageBuffer* imageBuffer);

#endif // CameraTypes_h
