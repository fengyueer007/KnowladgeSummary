//
//  CreateTwoDimensionCodeAndZBarViewController.m
//  
//
//  Created by admin on 15/11/10.
//
//

#import "CreateTwoDimensionCodeAndZBarViewController.h"
#import "QRCodeGenerator.h"
@interface CreateTwoDimensionCodeAndZBarViewController ()

@end

@implementation CreateTwoDimensionCodeAndZBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initFrame];
    
}

#pragma mark 初始化界面
-(void)initFrame{
    _text = [[UITextField alloc]initWithFrame:CGRectMake(20, 70, 188, 31)];
    _text.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_text];
    _text.placeholder = @"输入字符串生成二维码";
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createBtn.backgroundColor = [UIColor whiteColor];
    createBtn.frame = CGRectMake(228, 70, 72, 31);
    createBtn.layer.cornerRadius = 5;
    createBtn.layer.masksToBounds = YES;
    [self.view addSubview:createBtn];
    [createBtn setTitle:@"生成" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createTwoDimensionCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 220)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 230, 40)];
    _label.text = @"扫描二维码，请在真机测试！！";
    [self.view addSubview:_label];
    
    UIButton *scaningBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scaningBtn setFrame:CGRectMake(260, 340, 40, 40)];
    scaningBtn.layer.cornerRadius = 5;
    scaningBtn.layer.masksToBounds = YES;
    scaningBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scaningBtn];
    [scaningBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [scaningBtn addTarget:self action:@selector(scaningTwoDimensionCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 生成方法
-(void)createTwoDimensionCodeBtn{
    [_text resignFirstResponder];
    _imageView.image = [QRCodeGenerator qrImageForString:_text.text imageSize:_imageView.bounds.size.width];
}

#pragma mark 扫描方法
-(void)scaningTwoDimensionCodeBtn{
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
//    ZBarReaderViewController *reader_ = [ZBarReaderViewController new];
//    reader_.readerDelegate = self;
//    reader_.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader_.scanner;
//    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//    [self presentModalViewController:reader_ animated:YES];
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    
//    
//    _imageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
//    [picker dismissModalViewControllerAnimated:YES];
//    //判断是否包含 头'http:'
//    NSString *regex = @"http+:[^\\s]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    
//    //判断是否包含 头'ssid:'
//    NSString *ssid = @"ssid+:[^\\s]*";;
//    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//    _label.text =  symbol.data ;
//    
//    if ([predicate evaluateWithObject:_label.text]) {
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
//                                                        message:@"It will use the browser to this URL。"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Close"
//                                              otherButtonTitles:@"Ok", nil];
//        alert.delegate = self;
//        alert.tag=1;
//        [alert show];
//        
//        
//        
//    }
//    else if([ssidPre evaluateWithObject:_label.text]){
//        
//        NSArray *arr = [_label.text componentsSeparatedByString:@";"];
//        
//        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
//        
//        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
//        
//        
//        _label.text=
//        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
//         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
//        
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:_label.text
//                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Close"
//                                              otherButtonTitles:@"Ok", nil];
//        
//        
//        alert.delegate = self;
//        alert.tag=2;
//        [alert show];
//        
//        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
//        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
//        pasteboard.string = [arrInfoFoot objectAtIndex:1];
//        
//        
//    }
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_text resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
