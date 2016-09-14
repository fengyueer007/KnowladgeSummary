//
//  TwoViewController.h
//  
//
//  Created by admin on 15/11/26.
//
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface TwoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *personImage;//头像
@property (weak, nonatomic) IBOutlet UITextField *personPhoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *personVerificationTextField;//验证码
- (IBAction)obtainVerification:(id)sender;//获取验证码
- (IBAction)loginVerification:(id)sender;//登录
- (IBAction)obtainPersonImageBtn:(id)sender;

- (IBAction)registeredPersonBtn:(id)sender;//注册


@end
