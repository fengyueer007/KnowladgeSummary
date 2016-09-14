//
//  RegisteredViewController.h
//  
//
//  Created by admin on 15/12/4.
//
//

#import <UIKit/UIKit.h>

@interface RegisteredViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *loginTableView;
- (IBAction)registeredBtn:(id)sender;

@end
