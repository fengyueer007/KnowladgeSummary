//
//  CreateTwoDimensionCodeAndZBarViewController.h
//  
//
//  Created by admin on 15/11/10.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface CreateTwoDimensionCodeAndZBarViewController : UIViewController<ZBarReaderDelegate,UIAlertViewDelegate>


@property (nonatomic,retain) UITextField *text;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *label;



@end
