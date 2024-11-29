#include "CameraController.hpp"

#include <UIKit/UIKit.h>

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

- (bool) connect {
	if ([self isAuthorized] == false)
		return false;
	
	self.isWebCam = false;
	self.isConnected = false;
	
	bool isFound = false;
	AVCaptureDevice* captureDevice = nil;
	NSArray* allTypes = @[AVCaptureDeviceTypeExternal];
	AVCaptureDeviceDiscoverySession* discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	NSArray* devices = discoverySession.devices;
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
				captureDevice = device;
				NSLog(@"[connect] Find External Camera: %s\n", name);
				break;
			}
		}
	}
	
	NSLog(@"[connect] Unique ID: %@, Model ID: %@", captureDevice.uniqueID, captureDevice.modelID);
	
	if (self.isWebCam == false) {
		AVCaptureDeviceFormat* desiredFormat = nil;
		int maxWidth = 0;
		int maxHeight = 0;
		NSArray* availableFormats = captureDevice.formats;
		for (AVCaptureDeviceFormat* format in availableFormats) {
			// Get the format description for this format
			CMFormatDescriptionRef formatDescription = format.formatDescription;
			
			// Get the dimensions (resolution) of the video format
			CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
			
			// Get the resolution
			CGFloat width = dimensions.width;
			CGFloat height = dimensions.height;
			
			// Get the pixel format type from the format description
			OSType pixelFormat = CMFormatDescriptionGetMediaSubType(formatDescription);
			// Check and log the pixel format
			switch (pixelFormat) {
				case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
					NSLog(@"[connect] Pixel Format: 420YpCbCr8BiPlanarFullRange");
					desiredFormat = format;
					maxWidth = width;
					maxHeight = height;
					break;
				case kCVPixelFormatType_420YpCbCr8PlanarFullRange:
					NSLog(@"[connect] Pixel Format: 420YpCbCr8PlanarFullRange");
					break;
				case kCVPixelFormatType_420YpCbCr8Planar:
					NSLog(@"[connect] Pixel Format: 420YpCbCr8Planar");
					break;
				case kCVPixelFormatType_32BGRA:
					NSLog(@"[connect] Pixel Format: 32BGRA");
					break;
				default:
					NSLog(@"[connect] Unknown Pixel Format: %u", pixelFormat);
					break;
			}
			
			// Get the supported frame rate ranges for this format
			NSArray *frameRateRanges = format.videoSupportedFrameRateRanges;
			
			// Loop through each frame rate range and log the min and max FPS
			for (AVFrameRateRange *frameRateRange in frameRateRanges) {
				float minFrameRate = frameRateRange.minFrameRate;
				float maxFrameRate = frameRateRange.maxFrameRate;
				
				// Log the frame rate range
				NSLog(@"[connect] Supported FPS for format: %.2f - %.2f fps", minFrameRate, maxFrameRate);
			}
		}
		
		// Log or process the resolution
		NSLog(@"[connect] Supported Resolution: %.0dx%.0d", maxWidth, maxHeight);
		
		
		if (desiredFormat) {
			NSError *error = nil;
			if ([captureDevice lockForConfiguration:&error]) {
				
				captureDevice.activeFormat = desiredFormat;
				
				[captureDevice unlockForConfiguration];
			} else {
				NSLog(@"[connect] Error locking device for configuration: %@", error.localizedDescription);
			}
		} else {
			NSLog(@"[connect] Desired format not found.");
		}
	}
	
	self.captureSession = [[AVCaptureSession alloc] init];
	if (!self.captureSession) {
		NSLog(@"[connect] Cannot found capture session");
	}
	
	[self.captureSession beginConfiguration];
	
	@try {
		// Camera Device Input 만들기
		AVCaptureDeviceInput* videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
		if (!videoInput) {
			NSLog(@"[connect] Cannot found video input");
		}
		
		if (![self.captureSession canAddInput:videoInput]) {
			NSLog(@"[connect] Cannot found video input session");
			return false;
		}
		
		// Capture Session에 AVCaptureDeviceInput 객체 추가
		[self.captureSession addInput:videoInput];
	} @catch (NSException *exception) {
		NSLog(@"[connect] %@", exception.reason);
	}
	
	NSLog(@"[connect] Add output");
	AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	if (!videoOutput) {
		NSLog(@"[connect] Cannot found video output");
	}
	
	// Video output에 Pixel Format 설정
	if (self.isWebCam) {
		NSDictionary* videoSettings = @{
			(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
		};
		videoOutput.videoSettings = videoSettings;
	}
	else {
		NSDictionary* videoSettings = @{
			(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange),
			// kCVPixelFormatType_Lossy_420YpCbCr8BiPlanarFullRange
			// kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
			// kCVPixelFormatType_32BGRA
			(id)kCVPixelBufferWidthKey : @(1104),  // maxWidth // 1920 // 1104
			(id)kCVPixelBufferHeightKey : @(6440) // maxHeight // 1080 // 6440
		};
		videoOutput.videoSettings = videoSettings;
	}
	
	NSLog(@"[connect] videoDataOutput.videoSettings: %@", videoOutput.videoSettings);
	
	if (![self.captureSession canAddOutput:videoOutput]) {
		NSLog(@"[connect] Cannot found video output session");
		return false;
	}
	
	// Capture Session에 AVCaptureDeviceOutput 객체 추가
	[self.captureSession addOutput:videoOutput];
	
	// Buffer 설정
	self.videoQueue = dispatch_queue_create("videoQueue", DISPATCH_QUEUE_SERIAL);
	[videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
	
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
	
	self.videoQueue = NULL;
	
	return true;
}

- (bool) startStreaming {
	if (self.captureSession.isRunning) {
		return true;
	}
	
	NSLog(@"[startStreaming] session start %@", self.captureSession);
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
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
	
	NSLog(@"[stopStreaming] session stop");
	[self.captureSession stopRunning];
	
	return true;
}

// https://gist.github.com/AllanChen/94bb2a0f418af25bdfd408076408516d
// https://stackoverflow.com/questions/25659671/how-to-convert-from-yuv-to-ciimage-for-ios
int imageSaveCount = 0;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	// Get Raw Pixel
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	
	// lock image buffer
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	/*
	CIImage* image = [CIImage imageWithCVPixelBuffer:imageBuffer];
	if ([self.cameraManagerDelegate respondsToSelector:@selector(captureImageOutput:)]) {
		[self.cameraManagerDelegate captureImageOutput:image];
	}
	*/
	uint8_t* baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
	
	size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
	size_t bufferWidth = CVPixelBufferGetWidth(imageBuffer);
	size_t bufferHeight = CVPixelBufferGetHeight(imageBuffer);
	size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
	
	NSLog(@"bytesPerRow: %zu, bufferWidth: %zu, bufferHeight: %zu, bufferSize: %zu", bytesPerRow, bufferWidth, bufferHeight, bufferSize);
	
	// 방법 1
	NSData* nsData = [NSData dataWithBytes:baseAddress length:bufferSize];
	NSUInteger len = [nsData length];
	unsigned char* byteData = (unsigned char*)malloc(len);
	memcpy(byteData, [nsData bytes], len);
	
	NSLog(@"%02X, %02X", byteData[0], byteData[1]);
	
	if (self.isWebCam == false) {
		return;
	}
	
	//NSData* resultData = [NSData dataWithBytes:byteData length:sizeof(byteData)];
	
	// Create a Quartz direct-access data provider that uses data we supply.
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, byteData, bufferSize, NULL);
	// Create a bitmap image from data supplied by the data provider.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef cgImage = CGImageCreate(bufferWidth, bufferHeight, 8, 32, bytesPerRow,
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
	CGImageRef cgImage = CGImageCreate(bufferWidth, bufferHeight, 8, 32, bytesPerRow,
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
	CGContextRef context = CGBitmapContextCreate(baseAddress, bufferWidth, bufferHeight, 8, bytesPerRow,
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
