#ifndef CameraExport_h
#define CameraExport_h

#import <Foundation/Foundation.h>

@interface CameraExport : NSObject

- (bool) connect;
- (bool) isConnected;
- (bool) disconnect;
- (bool) startStreaming;
- (bool) stopStreaming;
- (bool) isStreaming;

@end // CameraExport

#endif // CameraExport_h
