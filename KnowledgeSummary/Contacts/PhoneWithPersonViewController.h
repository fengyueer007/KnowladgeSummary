//
//  PhoneWithPersonViewController.h
//  
//
//  Created by admin on 15/12/1.
//
//

#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface PhoneWithPersonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CLTreeViewNode *node;

@end
