//
//  RegisteredViewController.m
//  
//
//  Created by admin on 15/12/4.
//
//

#import "RegisteredViewController.h"
#import "PresonSQLList.h"
@interface RegisteredViewController ()

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableString = @"tableString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableString];
    }
    UIView *cellView = [[UIView alloc]initWithFrame:cell.bounds];
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [cellView addSubview:cellImageView];
    UITextField *cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, cell.frame.size.width - 55, 40)];
    cellTextField.keyboardType= UIKeyboardTypeNumberPad;
    cellTextField.delegate = self;
    [cellView addSubview:cellTextField];
    [cell.contentView addSubview:cellView];
    if (indexPath.row == 0) {
        cellImageView.image =[UIImage imageNamed:@"user_normal"];
        cellTextField.placeholder = @"请输入电话号码";
        cellTextField.tag = 111;
    }
    else if (indexPath.row == 1){
        cellImageView.image = [UIImage imageNamed:@"global_normal"];
        cellTextField.placeholder = @"请输入密码";
        cellTextField.tag = 222;
    }else if (indexPath.row == 2){
        cellImageView.image = [UIImage imageNamed:@"global_normal"];
        cellTextField.placeholder = @"确认密码";
        cellTextField.tag = 333;
    }
//    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
    int length = (int)newStr.length;
    if (length >11)
    {
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    UITextField *text2 = (UITextField *)[self.view viewWithTag:222];
    UITextField *text3 = (UITextField *)[self.view viewWithTag:333];
    if (textField.tag == 111) {
        if (![textField.text isEqualToString:@""]&&![self validatePhone:textField.text]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写正确手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    if (textField.tag == 222 && ![text3.text isEqualToString:@""]) {
        if (![text3.text isEqualToString:textField.text ]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    if (textField.tag == 333) {
        if (![text2.text isEqualToString:textField.text ]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

#pragma mark 验证手机号
-(BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
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

- (IBAction)registeredBtn:(id)sender {
    
    UITextField * str1 = (UITextField *)[self.view viewWithTag:111];
    UITextField * str2 = (UITextField *)[self.view viewWithTag:222];
    if (![self validatePhone:str1.text]||[str2.text isEqualToString:@""]) {
        return;
    }
    PresonSQLList *sql = [[PresonSQLList alloc]init];
    NSString *string = [sql createUser:str1.text andPwd:str2.text];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    if ([string isEqualToString:@"注册成功"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
