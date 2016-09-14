//
//  PersonalViewController.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCameraRotator.h"
@interface PersonalViewController : UIViewController<RSCameraRotatorDelegate>
@property (nonatomic,strong)RSCameraRotator *rotator;
@end
