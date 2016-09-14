//
//  TwoDimensionCodeController.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/6.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface TwoDimensionCodeController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end
