//
//  TwoViewController.m
//  
//
//  Created by admin on 15/11/26.
//
//

#import "TwoViewController.h"
#import "RegisteredViewController.h"
#import "PresonSQLList.h"
@interface TwoViewController (){

    UIImagePickerController *pickerC;
    NSString *verificationString;
}

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _personPhoneTextField.delegate = self;
    PresonSQLList *sql = [[PresonSQLList alloc]init];
    [sql createPresonSQLList];
    [self setPicker];
}
#pragma mark 设置
-(void)setPicker{
    pickerC = [[UIImagePickerController alloc]init];
    pickerC.delegate = self;
    //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
    pickerC.allowsEditing = YES;
/*
    //指定使用照相机模式,可以指定使用相册／照片库
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置使用后置摄像头，可以使用前置摄像头
    pickerC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    //设置闪光灯模式
    pickerC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    //设置相机支持的类型，拍照和录像
    //返回类型有kUTTypeMovie,kUTTypeImage，其他类型均在<MobileCoreServices/MobileCoreServices.h>下
    pickerC.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    //设置拍摄时屏幕的view的transform属性，可以实现旋转，缩放功能
    //所有含有cameraXXX的属性都必须要sourceType是UIImagePickerControllerSourceTypeCamera时设置才有效果，否则会有异常
    //    pickerC.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*45/180);
    //    pickerC.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
    
    
    //判断是否支持照相机、图片库、相册功能
    BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    NSLog(@"support camera:%d",isCameraSupport);
    
    //静态方法判断设备是否支持前置摄像头／后置摄像头
    BOOL isRearSupport = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    NSLog(@"rear support:%d",isRearSupport);
    
    //静态方法判断设备是否支持前置摄像头闪光灯／后置摄像头闪光灯
    BOOL isFlushSupport = [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    NSLog(@"rear flash support:%d",isFlushSupport);
    
    //静态方法返回前置摄像头／后置摄像头支持的拍摄类型
    NSArray *captureModes = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    for (NSNumber *mode in captureModes) {
        NSLog(@"capture modes:%ld",(long)[mode integerValue]);
    }
    
    //静态方法返回照相机／相册／照片库所支持的媒体类型
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    for (NSString *type in mediaTypes) {
        NSLog(@"media types:%@",type);
    }
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 验证
- (IBAction)obtainVerification:(id)sender {
    NSString *message = nil;
    if ([self validatePhone:_personPhoneTextField.text]) {
        PresonSQLList *sql = [[PresonSQLList alloc]init];
        message = [sql insertSecurityCode:_personPhoneTextField.text];
        verificationString = message;
    }else{
        message = @"请填写正确的手机号";
        
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark 登录
- (IBAction)loginVerification:(id)sender {
    NSString *message = nil;
    if ([self validatePhone:_personPhoneTextField.text]) {
        PresonSQLList *sql = [[PresonSQLList alloc]init];
        NSString *securityCode = [sql selestSecurityCode:_personPhoneTextField.text];
        if ([securityCode isEqualToString:verificationString]) {
            message = @"登录成功";
        }else{
            message = @"验证码不正确";
        }
    }else{
        message = @"请填写正确的手机号";
        
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark 注册
- (IBAction)registeredPersonBtn:(id)sender {
    RegisteredViewController *registeredVC = [[RegisteredViewController alloc]init];
    [self presentViewController:registeredVC animated:YES completion:nil];
}


#pragma mark 验证手机号
-(BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_personPhoneTextField resignFirstResponder];
    [_personVerificationTextField resignFirstResponder];
}

#pragma mark - 进入相册
- (IBAction)obtainPersonImageBtn:(id)sender {
    [self presentViewController:pickerC animated:YES completion:nil];
    
}


#pragma mark 成功获得相片还是视频后的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString *)kUTTypeImage]&& (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary||UIImagePickerControllerSourceTypeCamera)) {
        //获取照片的原图
//        UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
        UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片裁剪后，剩下的图
//        UIImage *crop = [info objectForKey:UIImagePickerControllerCropRect];
        //获取图片的url
//        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
         //获取图片的metadata数据信息
//        NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        _personImage.image = edit;
    }else{
        
    }
    [pickerC dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [pickerC dismissViewControllerAnimated:YES completion:nil];
}

//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}
@end
