#ifndef CameraModule_h
#define CameraModule_h

#import <Foundation/Foundation.h>

@interface CameraModule : NSObject

- (bool) connect;
- (bool) isConnected;
- (bool) disconnect;
- (bool) startStreaming;
- (bool) stopStreaming;
- (bool) isStreaming;

@end // CameraModule

#endif // CameraModule_h
