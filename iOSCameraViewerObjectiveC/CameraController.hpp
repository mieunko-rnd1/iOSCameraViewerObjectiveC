#ifndef CameraController_h
#define CameraController_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
@protocol CameraManagerDelegate <NSObject>

- (void)captureImageOutput:(CIImage*)image;

@end
*/

@interface CameraController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDevice* captureDevice;
@property (nonatomic, strong) AVCaptureSession* captureSession;
@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic) bool isWebCam;
@property (nonatomic) bool isConnected;

//@property (nonatomic, weak) id<CameraManagerDelegate> cameraManagerDelegate;


- (bool) isAuthorized;
- (bool) isCameraExist;
- (NSString*) getDetectCameraDeviceName;
- (bool) setVideoInputFormat: (int)width height:(int)height frameRate:(float)frameRate fourCC:(NSString*)fourCC;
- (bool) prepareVideoInput;
- (bool) prepareVideoOutput;

- (bool) connect;
- (bool) disconnect;
- (bool) startStreaming;
- (bool) stopStreaming;
- (void) captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection;

@end // CameraController

#endif // CameraController_h
