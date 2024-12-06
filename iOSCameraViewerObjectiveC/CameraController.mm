#import "CameraController.h"
#import "CameraHelper.h"
#import "CameraTypes.h"

#import <UIKit/UIKit.h>

#include <iostream>

@implementation CameraController

- (bool) isAuthorized {
	bool isAuth = false;
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if (status == AVAuthorizationStatusAuthorized) {
		isAuth = true;
	}
	
	if (status == AVAuthorizationStatusNotDetermined) {
		NSLog(@"권한 요청 전 상태");
		// 권한 요청
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
			if (granted) {
				NSLog(@"권한 허용");
			}
			else {
				NSLog(@"권한 거부");
			}
		}];
		
		status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		if (status == AVAuthorizationStatusAuthorized)
			isAuth = true;
	}
	
	return isAuth;
}

- (bool) isCameraExist {
	NSArray* allTypes = @[AVCaptureDeviceTypeExternal];
	AVCaptureDeviceDiscoverySession* sessions = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	NSArray* devices = sessions.devices;
	bool isFound = false;
	
	if ([devices count] == 0)
		return isFound;
	
	for (AVCaptureDevice* device in devices) {
		if([device deviceType] == AVCaptureDeviceTypeExternal) {
			const char* name = [[device localizedName] UTF8String];
			NSString* strName = [NSString stringWithUTF8String:name];
			if ([strName  isEqual: @"C270 HD WEBCAM"]) {
				isFound = true;
				self.isWebCam = true;
			}
			else if ([strName  isEqual: @"Medit MO3"]) {
				isFound = true;
			}
			
			if (isFound) {
				break;
			}
		}
	}
	
	return isFound;
}

- (NSString*) getDetectCameraDeviceName {
	NSArray* allTypes = @[AVCaptureDeviceTypeExternal];
	AVCaptureDeviceDiscoverySession* sessions = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	NSArray* devices = sessions.devices;
	
	if ([devices count] == 0)
		return @"";
	
	for (AVCaptureDevice* device in devices) {
		if([device deviceType] == AVCaptureDeviceTypeExternal) {
			const char* name = [[device localizedName] UTF8String];
			NSString* strName = [NSString stringWithUTF8String:name];
			if ([strName  isEqual: @"C270 HD WEBCAM"]) {
				return strName;
			}
			else if ([strName  isEqual: @"Medit MO3"]) {
				return strName;
			}
		}
	}
	
	return @"";
}

- (bool) setVideoInputFormat: (int)width height:(int)height frameRate:(float)frameRate fourCC:(NSString*)fourCC {
	if (!self.captureDevice) {
		return false;
	}
	
	NSArray* availableFormats = self.captureDevice.formats;
	for (AVCaptureDeviceFormat* format in availableFormats) {
		CMFormatDescriptionRef description = format.formatDescription;
		CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(description);
		
		NSArray* frameRateRanges = format.videoSupportedFrameRateRanges;
		float minFrameRate = 0.0f;
		float maxFrameRate = 0.0f;
		if ([frameRateRanges count] == 0) {
			return false;
		}
		
		AVFrameRateRange* frameRateRange = [format.videoSupportedFrameRateRanges objectAtIndex:0];
		minFrameRate = frameRateRange.minFrameRate;
		maxFrameRate = frameRateRange.maxFrameRate;
		
		OSType subType = CMFormatDescriptionGetMediaSubType(description);
		NSString* fourCCString = [NSString stringWithFormat:@"%c%c%c%c",
								  (subType >> 24) & 0xff,
								  (subType >> 16) & 0xff,
								  (subType >> 8) & 0xff,
								  subType & 0xff];
		
		if ((dimensions.width == width) && (dimensions.height == height) && [fourCCString isEqualToString:fourCC]  &&
			(minFrameRate <= frameRate) && (maxFrameRate >= frameRate)) {
			NSError *error;
			if (![self.captureDevice lockForConfiguration:&error]) {
				NSLog(@"Could not lock device %@ for configuration: %@", self, error);
				return false;
			}
			
			self.captureDevice.activeFormat = format;
			self.captureDevice.activeVideoMinFrameDuration = CMTimeMake(1, frameRate);
			self.captureDevice.activeVideoMaxFrameDuration = CMTimeMake(1, frameRate);
			
			[self.captureDevice unlockForConfiguration];
			
			return true;
		}
	}
	
	return false;
}

- (bool) prepareVideoInput {
	if (!self.captureSession || !self.captureDevice) {
		return false;
	}
	
	@try {
		// 원하는 포맷 설정
		int width = 1104;
		int height = 6440;
		double frameRate = 30.0;
		NSString* fourCC = @"420f"; // 예: "420v" 또는 "420f"
		
		if ([self setVideoInputFormat:width height:height frameRate:frameRate fourCC:fourCC] == false) {
			NSLog(@"Failed to set video format...!");
			return false;
		}
		
		// Camera Device Input 만들기
		AVCaptureDeviceInput* videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
		if (!videoInput) {
			NSLog(@"Cannot found video input...!");
			return false;
		}
		
		if (![self.captureSession canAddInput:videoInput]) {
			NSLog(@"Cannot found video input session...!");
			return false;
		}
		
		// Capture Session에 AVCaptureDeviceInput 객체 추가
		[self.captureSession addInput:videoInput];
	} @catch (NSException *exception) {
		NSLog(@"Cannot found video input ... %@", exception.reason);
		return false;
	}
	
	return true;
}

- (bool) prepareVideoOutput {
	if (!self.captureSession) {
		return false;
	}
	
	AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
	if (!output) {
		NSLog(@"Cannot found video output...!");
	}
	
	// Video output에 Pixel Format 설정
	if (self.isWebCam) {
		NSDictionary* videoSettings = @{
			(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
		};
		output.videoSettings = videoSettings;
	}
	else {
		NSDictionary* videoSettings = @{
			(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
			(id)kCVPixelBufferWidthKey : @(1104),  // maxWidth // 1920 // 1104
			(id)kCVPixelBufferHeightKey : @(6440) // maxHeight // 1080 // 6440
		};
		
		output.videoSettings = videoSettings;
	}
	
	if (![self.captureSession canAddOutput:output]) {
		NSLog(@"Cannot found video output session...!");
		return false;
	}
	
	// Capture Session에 AVCaptureDeviceOutput 객체 추가
	[self.captureSession addOutput:output];
	
	// Buffer 설정
	self.videoQueue = dispatch_queue_create("videoQueue", DISPATCH_QUEUE_SERIAL);
	[output setSampleBufferDelegate:self queue:self.videoQueue];
	
	return true;
}

- (bool) connect {
	if ([self isAuthorized] == false) {
		NSLog(@"Permission is not granted...!");
		return false;
	}
	
	if ([self isCameraExist] == false) {
		NSLog(@"Cannot found camera device...!");
		return false;
	}
	
	if ([self getDetectCameraDeviceName].length == 0) {
		NSLog(@"Cannot detect camera device name...!");
		return false;
	}
	
	self.isWebCam = false;
	self.isConnected = false;
	
	bool isFound = false;
	NSArray* allTypes = @[AVCaptureDeviceTypeExternal];
	AVCaptureDeviceDiscoverySession* discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	NSArray* devices = discoverySession.devices;
	
	if ([devices count] == 0) {
		NSLog(@"Cannot found capture devices...!");
		return false;
	}
	
	// Capture Session에 대한 입력을 제공
	for (AVCaptureDevice* device in devices) {
		if([device deviceType] == AVCaptureDeviceTypeExternal) {
			const char* name = [[device localizedName] UTF8String];
			NSString* strName = [NSString stringWithUTF8String:name];
			if ([strName  isEqual: @"C270 HD WEBCAM"]) {
				isFound = true;
				self.isWebCam = true;
			}
			else if ([strName  isEqual: @"Medit MO3"]) {
				isFound = true;
			}
			
			if (isFound) {
				self.captureDevice = device;
				NSLog(@"Find External Camera: %s\n", name);
				break;
			}
		}
	}
	
	NSLog(@"Unique ID: %@, Model ID: %@", self.captureDevice.uniqueID, self.captureDevice.modelID);
	
	self.captureSession = [[AVCaptureSession alloc] init];
	if (!self.captureSession) {
		NSLog(@"Cannot found capture session...!");
		return false;
	}
	
	self.captureSession.sessionPreset = AVCaptureSessionPresetInputPriority;
	
	[self.captureSession beginConfiguration];
	
	if ([self prepareVideoInput] == false) {
		NSLog(@"Cannot found video input...!");
		[self.captureSession commitConfiguration];
		return false;
	}
	
	if ([self prepareVideoOutput] == false) {
		NSLog(@"Cannot found video output...!");
		[self.captureSession commitConfiguration];
		return false;
	}
	
	[self.captureSession commitConfiguration];
	
	self.isConnected = true;
	
	return true;
}

- (bool) disconnect {
	self.isConnected = false;
	
	[self.captureSession beginConfiguration];
	
	for (AVCaptureDeviceInput* input in [self.captureSession inputs]) {
		[self.captureSession removeInput: input];
	}
	
	for (AVCaptureVideoDataOutput* output in [self.captureSession outputs]) {
		[output setSampleBufferDelegate:nil queue:NULL];
		[self.captureSession removeOutput: output];
	}
	
	[self.captureSession commitConfiguration];
	
	self.captureDevice = NULL; // ????
	self.videoQueue = NULL;
	
	return true;
}

- (bool) startStreaming {
	if (self.captureSession.isRunning) {
		return true;
	}
	
	NSLog(@"session start %@", self.captureSession);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
		//Background Thread
		dispatch_async(self.videoQueue, ^(void){
			//Run UI Updates
			[self.captureSession startRunning];
		});
	});
	/*
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//dispatch_async( self.sampleBufferCallbackQueue, ^{
		//dispatch_async(self.sampleBufferCallbackQueue, ^{
			
			[self.captureSession startRunning];
		//});
	});
	*/
	return true;
}

- (bool) stopStreaming {
	if (self.captureSession.isRunning == false) {
		return true;
	}
	
	NSLog(@"session stop");
	[self.captureSession stopRunning];
	
	return true;
}

// https://gist.github.com/AllanChen/94bb2a0f418af25bdfd408076408516d
// https://stackoverflow.com/questions/25659671/how-to-convert-from-yuv-to-ciimage-for-ios
unsigned int imageSaveCount = 0;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	// Get Raw Pixel
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

	// lock image buffer
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	
	uint8_t* baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
	
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	size_t width = CVPixelBufferGetWidth(imageBuffer);
	size_t height = CVPixelBufferGetHeight(imageBuffer);
	size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
	
	// 방법 1
	NSData* nsData = [NSData dataWithBytes:baseAddress length:bufferSize];
	NSUInteger len = [nsData length];
	unsigned char* byteData = (unsigned char*)malloc(len);
	memcpy(byteData, [nsData bytes], len);
	
	std::shared_ptr<ImageBuffer> imageBufferInfo = std::make_shared<ImageBuffer>(byteData,
																				 static_cast<unsigned int>(width),
																				 static_cast<unsigned int>(height),
																				 static_cast<unsigned int>(bufferSize),
																				 static_cast<unsigned int>(bytesPerRow),
																				 imageSaveCount);
	Camera::ImageCallbacks::updateImageCallback(imageBufferInfo);
	
	/*
	if (self.isWebCam == false) {
		return;
	}
	*/
	//NSData* resultData = [NSData dataWithBytes:byteData length:sizeof(byteData)];
	
	// Create a Quartz direct-access data provider that uses data we supply.
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, byteData, bufferSize, NULL);
	// Create a bitmap image from data supplied by the data provider.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow,
									   rgbColorSpace, kCGImageAlphaNoneSkipFirst | (CGBitmapInfo)kCGBitmapByteOrder32Little,
									   dataProvider, NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(dataProvider);
	
	// unlock image buffer
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
 
	// Create and return an image object to represent the Quartz image.
	UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);

/*
	// 방법 2
	// Create a Quartz direct-access data provider that uses data we supply.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
	// Create a bitmap image from data supplied by the data provider.
	CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow,
									   rgbColorSpace, kCGImageAlphaNoneSkipFirst | (CGBitmapInfo)kCGBitmapByteOrder32Little,
									   dataProvider, NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(dataProvider);
	
	// Create and return an image object to represent the Quartz image.
	UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
*/
/*
	// 방법 3
	// Create a bitmap graphics context with the sample buffer data
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow,
												rgbColorSpace,
												(CGBitmapInfo)kCGBitmapByteOrder32Little |
												kCGImageAlphaPremultipliedFirst);
	
	// Create a cgi image from the pixel data in the bitmap graphics context
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	// unlock image buffer
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	
	// Free up the context and color space
	CGColorSpaceRelease(rgbColorSpace);
	CGContextRelease(context);
	
	//CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
	
	UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
	if (uiImage == NULL) {
		NSLog(@"Cannot convert to UIImage...!");
		return;
	}
	
	// Release the cgi image
	CGImageRelease(cgImage);
*/
	
	
	// File IO
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if([fileManager isWritableFileAtPath:documentsDirectory] == NO) {
		NSLog(@"Not writable path : %@ ...!", documentsDirectory);
		return;
	}
	
	NSString* fileName = [NSString stringWithFormat:@"rawData_%d.jpg",imageSaveCount];
	NSString* resultpath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	NSLog(@"Path : %@", resultpath);
	
	if([fileManager fileExistsAtPath: resultpath] == YES) {
		[fileManager removeItemAtPath: resultpath error:nil];
	}
	
	NSData* jpgData = UIImageJPEGRepresentation(uiImage, 1.0f);
	if (jpgData == NULL) {
		NSLog(@"Cannot convert to JPEG...!");
		return;
	}
	
	if ([jpgData writeToFile:resultpath atomically:NO] == NO) {
		NSLog(@"Cannot write file : %@", resultpath);
		return;
	}
	
		
	imageSaveCount++;
}

@end // CameraController
