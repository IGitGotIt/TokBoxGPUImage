//
//  TokBoxGPUImagePublisher.m
//  TokBoxGPUImage
//
//  Created by Jaideep Shah on 9/5/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "TokBoxGPUImagePublisher.h"
#import "GPUImage.h"
static double imageHeight = 480;
static double imageWidth = 640;


@interface TokBoxGPUImagePublisher() <GPUImageVideoCameraDelegate, OTVideoCapture> {
    GPUImageVideoCamera *videoCamera;
    GPUImageSepiaFilter *sepiaImageFilter;
    OTVideoFrame* videoFrame;
}

@end

@implementation TokBoxGPUImagePublisher

@synthesize videoCaptureConsumer ;  // In OTVideoCapture protocol

- (id)initWithDelegate:(id<OTPublisherDelegate>)delegate
                  name:(NSString*)name
{
    self = [super initWithDelegate:delegate name:name];
    if (self) {
        
        self.view = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self setVideoCapture:self];
        videoFrame = [[OTVideoFrame alloc] initWithFormat: [OTVideoFormat videoFormatNV12WithWidth:imageWidth
                                                                                            height:imageHeight]];
        

    }
    return self;
}
#pragma mark GPUImageVideoCameraDelegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    [videoFrame clearPlanes];
    
    for (int i = 0; i < CVPixelBufferGetPlaneCount(imageBuffer); i++) {
        [videoFrame.planes addPointer:CVPixelBufferGetBaseAddressOfPlane(imageBuffer, i)];
    }
    videoFrame.orientation = OTVideoOrientationLeft;

    [self.videoCaptureConsumer consumeFrame:videoFrame];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

    
}
#pragma mark OTVideoCapture

- (void) initCapture {
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                      cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    

    
    [videoCamera setDelegate:self];
    
    
    
//    sepiaImageFilter = [[GPUImageSepiaFilter alloc] init];
//    [videoCamera addTarget:sepiaImageFilter];
//    [sepiaImageFilter addTarget:self.view];
    
    [videoCamera addTarget:self.view];
    
    [videoCamera startCameraCapture];

}

- (void)releaseCapture
{
    videoCamera.delegate = nil;
    videoCamera = nil;
}
- (int32_t) startCapture {
    return 0;
}

- (int32_t) stopCapture {
    return 0;
}

- (BOOL) isCaptureStarted {
    return YES;
}
- (int32_t)captureSettings:(OTVideoFormat*)videoFormat {
    videoFormat.pixelFormat = OTPixelFormatNV12;
    videoFormat.imageWidth = imageWidth;
    videoFormat.imageHeight = imageHeight;
    return 0;

    return 0;
}
@end
