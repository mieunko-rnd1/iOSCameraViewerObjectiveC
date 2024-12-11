#ifndef HubCameraController_h
#define HubCameraController_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HubCameraController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice* captureDevice;
@property (nonatomic, strong) AVCaptureSession* captureSession;
@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic) bool isWebCam;
@property (nonatomic) bool isConnected;

- (bool) isAuthorized;
- (bool) isCameraExist;
- (NSString*) getDetectCameraDeviceName;
- (bool) setVideoInputFormat: (int)width height:(int)height frameRate:(float)frameRate fourCC:(NSString*)fourCC;
- (bool) prepareVideoInput;
- (bool) prepareVideoOutput;

- (bool) connect;
- (void) disconnect;
- (bool) startStreaming;
- (bool) stopStreaming;
- (void) captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection;

@end // HubCameraController

#endif // HubCameraController_h
