//
//  AdvertisingScrollViewController.m
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//
//广告滚动

#import "AdvertisingScrollViewController.h"
#import "CreateTwoDimensionCodeAndZBarViewController.h"
#import "AdView.h"
#import "PendulumView.h"
#import "GiFHUD.h"
#define MAIN_W self.view.frame.size.width
#define MAIN_H self.view.frame.size.height
#define ADVIEW_HEIGHT 200  //设置广告的 高度
@implementation AdvertisingScrollViewController
{
    UIWebView *webView;
//    PendulumView *pendulumView;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addAdView];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, ADVIEW_HEIGHT, MAIN_W, MAIN_H-ADVIEW_HEIGHT-50)];
    webView.delegate = self;
    [self.view addSubview:webView];
//    [self addPendulumView];
    [self addWebView:@"http://www.baidu.com"];
    [GiFHUD setGifWithImageName:@"pika.gif"];
}

-(void)addPendulumView{
//    UIColor *ballColor = [UIColor colorWithRed:0.47 green:0.60 blue:0.89 alpha:0.7];
//    pendulumView = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ballColor];
//
//    [pendulumView stopAnimating];
//    pendulumView.hidden = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:pendulumView];
    [GiFHUD setGifWithImageName:@"pika.gif"];
}

#pragma mark 添加webview
-(void)addWebView:(NSString *)webUrl{
    NSURL *url = [NSURL URLWithString:webUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
}

#pragma mark 添加广告图片url 数组
-(void)addAdView{
    //广告图片url 数组
    
    NSArray *imageLinkURLArray = [NSArray arrayWithObjects:
                                  @"http://developer.api.24tidy.com/upload/indexImg/ios/ios_20151030232058.png?27",
                                  @"http://developer.api.24tidy.com/upload/indexImg/ios/ios_20150930190023.jpg?6",
                                  @"http://developer.api.24tidy.com/upload/indexImg/ios/ios_20150930151117.jpg?57",
                                  @"http://developer.api.24tidy.com/upload/indexImg/ios/ios_20150529162330.jpg?54",
                                  @"http://developer.api.24tidy.com/upload/indexImg/ios/ios_20150427181249.png?49",
                                  nil];
    //设置广告的 frame
    AdView *adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, MAIN_W,ADVIEW_HEIGHT) imageLinkURL:imageLinkURLArray placeHoderImageName:@"zhanweitu.jpg" pageControlShowStyle:UIPageControlShowStyleCenter];
    [self.view addSubview:adView];
    
    NSArray *imageWebUrl = [NSArray arrayWithObjects:@"http://www.baidu.com",@"http://www.hao123.com",@"http://code4app.com",@"http://www.zhe800.com",@"http://www.taobao.com", nil];
    
    //图片的点击事件
    adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSString *weburl = [imageWebUrl objectAtIndex:index];
        [self addWebView:weburl];
    };
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    pendulumView.hidden = YES;
//    [pendulumView stopAnimating];
    [GiFHUD dismiss];


}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    pendulumView.hidden = YES;
//    [pendulumView stopAnimating];
    [GiFHUD dismiss];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [pendulumView startAnimating];
//    pendulumView.hidden = NO;
//    [GiFHUD show];
    [GiFHUD showWithOverlay];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
