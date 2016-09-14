//
//  TwoDimensionCodeController.m
//  KnowledgeSummary
//
//  Created by tidy on 15/11/6.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import "TwoDimensionCodeController.h"
#import "CreateTwoDimensionCodeAndZBarViewController.h"
@implementation TwoDimensionCodeController{
    UIImageView *line ;
    BOOL upOrDown;//扫描上下
    int num;//扫描
    NSTimer *timer;//定时器
}
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return  self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [createBtn setTitle:@"生成" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [createBtn setBackgroundColor:[UIColor whiteColor]];
    [createBtn addTarget:self action:@selector(createTwoDimensionCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc]initWithCustomView:createBtn];
    self.navigationItem.rightBarButtonItem = createItem;
    
    
    [self setFrame];
    [self setupCamera];
    
}
#pragma mark 开启摄像头
-(void)setupCamera{
    //Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    //Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    @try {
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(30, 100, self.view.bounds.size.width - 60, self.view.bounds.size.width - 60);
        [self.view.layer insertSublayer:_preview atIndex:0];
        [_session startRunning];
    }
    @catch(NSException *deviceException)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请开启摄像头权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark 输出二维码信息

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [_session stopRunning];
    AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
    NSString *strAV = metadataObject.stringValue;
    NSLog(@"%@",strAV);
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:web];
    NSURL *webUrl = [NSURL URLWithString:strAV];
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:webUrl];
    [web loadRequest:webRequest];
    
}

#pragma mark 扫描框位置
-(void)setFrame{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 90, self.view.frame.size.width - 40, self.view.frame.size.width - 40)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
//    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    UILabel *labIntroudction = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y + 10, self.view.frame.size.width, 20)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码图像置于矩形方框内";
    [self.view addSubview:labIntroudction];
    
    upOrDown = NO;
    num = 0;
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(30, 100, self.view.bounds.size.width-60, 2)];
    line.image = [UIImage imageNamed:@"Icon_QRCode_line"];
    [self.view addSubview:line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animationTimeWithLine) userInfo:nil repeats:YES];
    
}

-(void)animationTimeWithLine{
    if (upOrDown == NO) {
        num ++;
        line.frame = CGRectMake(30, 100+2*num, self.view.bounds.size.width - 60, 2);
        if (2 * num == self.view.bounds.size.width - 60) {
            upOrDown = YES;
        }
    }else{
        num --;
        line.frame = CGRectMake(30, 100+2*num, self.view.bounds.size.width - 60, 2);
        if (num == 0) {
            upOrDown = NO;
        }
    }
}

#pragma mark 生成二维码
-(void)createTwoDimensionCode{
    CreateTwoDimensionCodeAndZBarViewController *createVC = [[CreateTwoDimensionCodeAndZBarViewController alloc]init];
    [self.navigationController pushViewController:createVC animated:YES];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
