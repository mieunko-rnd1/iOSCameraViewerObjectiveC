#ifndef CameraControllerDelegate_h
#define CameraControllerDelegate_h

#import <Foundation/Foundation.h>

#include "CameraTypes.h"

// https://stackoverflow.com/questions/6903712/ios-protocols-and-delegates-on-the-example?rq=3
// https://github.com/dulingkang/DMScanCode/blob/master/DMCapture/DMVideoCamera.m
@protocol CameraControllerDelegate <NSObject>

- (bool)activateDelegate;
- (void)deactivateDelegate;

@optional
- (bool)getRawImageBuffer:(ImageBuffer&)imageBuffer;
- (void)captureImageOutput:(unsigned char*)image width:(size_t)width height:(size_t)height bufferSize:(size_t)bufferSize bytesPerRow:(size_t)bytesPerRow;

@end

#endif // CameraControllerDelegate_h
