#ifndef CameraModule_h
#define CameraModule_h

#import "CameraTypes.h"
#import "CameraHelper.h"

#import <Foundation/Foundation.h>

#import <functional>

@interface CameraModule : NSObject

- (bool) connect;
- (bool) isConnected;
- (bool) disconnect;
- (bool) startStreaming;
- (bool) stopStreaming;
- (bool) isStreaming;

@end // CameraModule

#endif // CameraModule_h
