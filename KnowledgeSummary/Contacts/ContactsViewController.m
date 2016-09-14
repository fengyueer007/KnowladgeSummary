//
//  ContactsViewController.m
//  
//
//  Created by admin on 15/11/10.
//
//

#import "ContactsViewController.h"
#import "ContactsListViewController.h"
#import "ChineseToPinyinViewController.h"
#import "PhoneWithPersonViewController.h"
#import "RCDraggableButton.h"
@interface ContactsViewController ()
{
    UILabel *phoneLable;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
}
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneDidSelect:) name:@"phoneDidSelect" object:nil];
    [self initFrame];
}

//有二级菜单时  是否可以继续点击
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}
//点击电话号码后
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    NSString *nameValue =(__bridge NSString *)(ABRecordCopyCompositeName(person));
    [self dismissViewControllerAnimated:YES completion:^{
        phoneLable.text = [NSString stringWithFormat:@"%@,%@",(__bridge NSString*)value,nameValue];
    }];
    return NO;
}

-(void)initFrame{
    phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 200, 40)];
    phoneLable.backgroundColor = [UIColor whiteColor];
    phoneLable.textColor = [UIColor greenColor];
    [self.view addSubview:phoneLable];
    
    UIButton *dhbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dhbBtn setFrame:CGRectMake(260, 100, 50, 40)];
    [dhbBtn setBackgroundColor:[UIColor redColor]];
    [dhbBtn setTitle:@"电话本" forState:UIControlStateNormal];
    [self.view addSubview:dhbBtn];
    [dhbBtn addTarget:self action:@selector(passPhoneBook) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *BtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width , 50)];
    BtnView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:BtnView];
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 250, 100, 40)];
    [self.view addSubview:textField];
//    textField.delegate = self;
    textField.backgroundColor = [UIColor greenColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:textField];
    
    
//    RCDraggableButton *btn = [[RCDraggableButton alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.height, self.view.frame.size.height)];
//    [self.view addSubview:btn];


    
//    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
//    [_longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
//    [_longPressGestureRecognizer setAllowableMovement:0];//设置允许的移动范围
//    [imageView addGestureRecognizer:_longPressGestureRecognizer];
    
}

-(void)passPhoneBook{
//    ContactsListViewController *couponVC = [[ContactsListViewController alloc] init];
//    UINavigationController *couponNav = [[UINavigationController alloc] initWithRootViewController:couponVC];
//    couponVC.modalTransitionStyle = UIModalPresentationPopover;
//    couponNav.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:1.0];
//    couponNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    
//    [couponVC didSelectPhoneNumber:^(NSDictionary *phoneDic) {
//        NSString *value = [phoneDic objectForKey:@"phoneNumber"];
//        NSString *nameValue = [phoneDic objectForKey:@"phoneName"];
//        phoneLable.text = [NSString stringWithFormat:@"%@,%@",value,nameValue];
//    }];
//    
//    [self presentViewController:couponNav animated:YES completion:nil];
    ChineseToPinyinViewController *couponVC = [[ChineseToPinyinViewController alloc] init];
    UINavigationController *couponNav = [[UINavigationController alloc] initWithRootViewController:couponVC];
    couponVC.modalTransitionStyle = UIModalPresentationPopover;
    couponNav.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:1.0];
    couponNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
//    [couponVC didSelectPhoneNumber:^(NSDictionary *phoneDic) {
//        NSString *value = [phoneDic objectForKey:@"phoneNumber"];
//        NSString *nameValue = [phoneDic objectForKey:@"phoneName"];
//        phoneLable.text = [NSString stringWithFormat:@"%@,%@",value,nameValue];
//    }];
    
    [self presentViewController:couponNav animated:YES completion:nil];
}

//-(void)passPhoneBook{
//    picker = [[ABPeoplePickerNavigationController alloc] init];
//    picker.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-48);
//    picker.peoplePickerDelegate = self;
//
//    [self presentViewController:picker animated:YES completion:nil];
//}

//电话本里面  取消
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker

{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker dismissModalViewControllerAnimated:YES];
}

-(void)phoneDidSelect:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSString *value = [info objectForKey:@"phoneNumber"];
    NSString *nameValue = [info objectForKey:@"phoneName"];
    phoneLable.text = [NSString stringWithFormat:@"%@,%@",value,nameValue];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSLog(@"%@",textField.text);
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
