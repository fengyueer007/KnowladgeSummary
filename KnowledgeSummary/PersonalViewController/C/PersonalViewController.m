//
//  PersonalViewController.m
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//
//个人信息

#import "PersonalViewController.h"
#import "TwoDimensionCodeController.h"
#import "ContactsViewController.h"
#import "SCNavTabBarController.h"
#import "DWBubbleMenuButton.h"
#import "UIButton+NMCategory.h"

#import <PassKit/PassKit.h>                                 //用户绑定的银行卡信息
#import <PassKit/PKPaymentAuthorizationViewController.h>    //Apple pay的展示控件
#import <AddressBook/AddressBook.h>                         //用户联系信息相关

@interface PersonalViewController ()<PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *summaryItems;
    NSMutableArray *shippingMethods;
}
@end

@implementation PersonalViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(san) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(0, 0, 40, 40);
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"btn_电话"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *phoneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:phoneBtn];
    self.navigationItem.leftBarButtonItem = phoneBtnItem;
    

    [self initVC];
    [self createHome];
}
#pragma mark - 创建菜单
-(void)createHome{
    UILabel *homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc]initWithFrame:CGRectMake(10, 100, homeLabel.frame.size.width,homeLabel.frame.size.height) expansionDirection:DirectionDown];
    downMenuButton.homeButtonView = homeLabel;
    [downMenuButton addButtons:[self createDemoButtonArray]];
    [self.view addSubview:downMenuButton];
}
-(UILabel *)createHomeButtonView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    label.text = @"菜单";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height/2;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor grayColor];
    
    return  label;
}

#pragma mark 添加菜单打开数组
-(NSArray *)createDemoButtonArray{
    NSMutableArray *buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
    int i = 0;
    NSArray *titleArray = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F", nil];
    for (NSString *title in titleArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 0, 30, 30);
        button.layer.cornerRadius = button.frame.size.height / 2;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor grayColor];
        button.tag = i++;
        [button addTarget:self action:@selector(passBtn:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
    }
    
    return buttonArray;
}

-(void)passBtn:(UIButton *)btn{
    NSLog(@"Button tag is %ld",btn.tag);
}


-(void)initVC{
    UIViewController *oneViewController = [[UIViewController alloc] init];
    oneViewController.title = @"新闻";
    
    _rotator = [[RSCameraRotator alloc]initWithFrame:CGRectMake(50, 50, 165, 40)];
    _rotator.tintColor = [UIColor blackColor];
    _rotator.offColor = [UIColor redColor];
    _rotator.onColorDark = [UIColor yellowColor];
    _rotator.onColorLight = [UIColor greenColor];
    _rotator.delegate = self;
    [oneViewController.view addSubview:_rotator];
    
    UIButton *phonePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phonePayBtn.frame = CGRectMake(100, 200, 40, 40);
    [oneViewController.view addSubview:phonePayBtn];
    //    [phonePayBtn setBackgroundImage:[UIImage imageNamed:@"btn_电话"] forState:UIControlStateNormal];
    [phonePayBtn setBackgroundColor:[UIColor redColor]];
    [phonePayBtn addTarget:self action:@selector(phone1) forControlEvents:UIControlEventTouchUpInside];
    
    oneViewController.view.backgroundColor = [UIColor brownColor];
    
    UIViewController *twoViewController = [[UIViewController alloc] init];
    twoViewController.title = @"体育";
    twoViewController.view.backgroundColor = [UIColor purpleColor];
    
    UIViewController *threeViewController = [[UIViewController alloc] init];
    threeViewController.title = @"娱乐八卦";
    threeViewController.view.backgroundColor = [UIColor orangeColor];
    
    UIViewController *fourViewController = [[UIViewController alloc] init];
    fourViewController.title = @"天府之国";
    fourViewController.view.backgroundColor = [UIColor magentaColor];
    
    UIViewController *fiveViewController = [[UIViewController alloc] init];
    fiveViewController.title = @"四川省";
    fiveViewController.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *sixViewController = [[UIViewController alloc] init];
    sixViewController.title = @"政治";
    sixViewController.view.backgroundColor = [UIColor cyanColor];
    
    UIViewController *sevenViewController = [[UIViewController alloc] init];
    sevenViewController.title = @"国际新闻";
    sevenViewController.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *eightViewController = [[UIViewController alloc] init];
    eightViewController.title = @"自媒体";
    eightViewController.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *ninghtViewController = [[UIViewController alloc] init];
    ninghtViewController.title = @"科技";
    ninghtViewController.view.backgroundColor = [UIColor redColor];
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[oneViewController, twoViewController, threeViewController, fourViewController, fiveViewController, sixViewController, sevenViewController, eightViewController, ninghtViewController];
    navTabBarController.showArrowButton = YES;
    [navTabBarController addParentController:self];

}

#pragma mark 开关 代理
-(void)clicked:(BOOL)isFront{
    if (isFront) {
        self.view.superview.backgroundColor = [UIColor yellowColor];
    }else{
        self.view.superview.backgroundColor = [UIColor blueColor];

    }
}

-(void)phone{
    ContactsViewController *contactsVC = [[ContactsViewController alloc]init];
    [self.navigationController pushViewController:contactsVC animated:YES];
}

-(void)phone1{
    if (![PKPaymentAuthorizationViewController class]) {
        //PKPaymentAuthorizationViewController需iOS8.0以上支持
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    //检查当前设备是否可以支付
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        //支付需iOS9.0以上支持
        NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return;
    }
    NSLog(@"可以支付，开始建立支付请求");
    //设置币种、国家码及merchant标识符等基本信息
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    payRequest.countryCode = @"CN";     //国家代码
    payRequest.currencyCode = @"CNY";       //RMB的币种代码
    payRequest.merchantIdentifier = @"merchant.ApplePayDemoYasin";  //申请的merchantID
    payRequest.supportedNetworks = supportedNetworks;   //用户可进行支付的银行卡
    payRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;      //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
    //    payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    //
    //设置两种配送方式
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    freeShipping.identifier = @"freeshipping";
    freeShipping.detail = @"6-8 天 送达";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    expressShipping.identifier = @"expressshipping";
    expressShipping.detail = @"2-3 小时 送达";
    shippingMethods = [NSMutableArray arrayWithArray:@[freeShipping, expressShipping]];
    //shippingMethods为配送方式列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行配送方式的调整。
    payRequest.shippingMethods = shippingMethods;
    
    
    
    NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];   //12.75
    PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:subtotalAmount];
    
    NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"-12.74"];      //-12.74
    PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"优惠折扣" amount:discountAmount];
    
    NSDecimalNumber *methodsAmount = [NSDecimalNumber zero];
    PKPaymentSummaryItem *methods = [PKPaymentSummaryItem summaryItemWithLabel:@"包邮" amount:methodsAmount];
    
    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
    totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
    totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
    totalAmount = [totalAmount decimalNumberByAdding:methodsAmount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Yasin" amount:totalAmount];  //最后这个是支付给谁。哈哈，快支付给我
    
    summaryItems = [NSMutableArray arrayWithArray:@[subtotal, discount, methods, total]];
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    payRequest.paymentSummaryItems = summaryItems;
    
    
    //ApplePay控件
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}

-(void)san{
    TwoDimensionCodeController *two = [[TwoDimensionCodeController alloc]init];
    [self.navigationController pushViewController:two animated:YES];
    

}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
