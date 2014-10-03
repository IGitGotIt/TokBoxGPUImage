//
//  TokBoxGPUImagePublisher.h
//  TokBoxGPUImage
//
//  Created by Jaideep Shah on 9/5/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import <OpenTok/OpenTok.h>
#import "GPUImage.h"

@interface TokBoxGPUImagePublisher : OTPublisherKit
@property(nonatomic, strong) GPUImageView * view;
@end
