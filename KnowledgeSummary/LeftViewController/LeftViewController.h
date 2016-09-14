//
//  LeftViewController.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/6.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhoto.h"
@interface LeftViewController : UIViewController<ZLPhotoPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UIView *contentView;
@end
