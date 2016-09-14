//
//  ContactsListViewController.m
//  
//
//  Created by admin on 15/11/17.
//
//

#import "ContactsListViewController.h"
#import "CLTreeViewNode.h"
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface ContactsListViewController ()<UISearchBarDelegate>

@property (strong ,nonatomic)NSMutableArray *dataArray;//保存全部数据的数组
@property (strong ,nonatomic)NSMutableArray *displayArray;//保存要显示在界面上的数据的数组
@property (strong ,nonatomic)UISearchBar *personSearchBar;
@end

@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"所有联系人";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _personSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    [_personSearchBar setPlaceholder:@"搜索"];
    [_personSearchBar setShowsCancelButton:NO];
    [_personSearchBar setDelegate:self];
    [_personSearchBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_personSearchBar];
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    btn.frame =CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=barBtn;
    [self setFrame];
    [self setDataForPhoneBook];
    
    
}

-(void)setFrame{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height-108)];
    _myTableView.delegate= self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}
-(void)setDataForPhoneBook{
//    NSMutableArray *tels = [[NSMutableArray alloc]initWithCapacity:0];
    //定义通讯录名字为addressbook
    ABAddressBookRef tmpAddressBook = nil;
    
    //根据系统版本不同，调用不同方法获取通讯录
    tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //取得通讯录失败
    if (tmpAddressBook==nil) {
        return ;
    };
    
    //将通讯录中的信息用数组方式读出
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    //遍历通讯录中的联系人
    for(id tmpPerson in tmpPeoples){
        
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        
        CLTreeViewNode *phoneNameNode = [[CLTreeViewNode alloc]init];
        phoneNameNode.phoneNum = nil;
        phoneNameNode.type = 1;
        phoneNameNode.isExpanded = NO;
        phoneNameNode.nodeData =[NSString stringWithFormat:@"%@%@",tmpLastName==nil?@"":tmpLastName,tmpFirstName==nil?@"":tmpFirstName];
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        
        NSMutableArray *phoneArray = [[NSMutableArray alloc]initWithCapacity:0];
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            NSString *tmpLabel = [self displayPropertyName:(__bridge NSString*)ABMultiValueCopyLabelAtIndex(tmpPhones, j)];
            NSDictionary *phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpPhoneIndex,@"tmpPhoneIndex",tmpLabel,@"tmpLabel", nil];
            [phoneArray addObject:phoneDic];
        }
        
        phoneNameNode.sonNodes = phoneArray;
        [_dataArray addObject:phoneNameNode];
    }
    
    [self reloadDataForDisplayArray];
    

}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    if (node.type == 2) {
        return 40;
    }
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _displayArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    NSString *indentifier = node.type == 2 ? @"level0cell_2" : @"level0cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (node.type == 2) {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 50, 40)];
        nameLabel.text = [node.phoneNum objectForKey:@"tmpLabel"];
        nameLabel.textAlignment = NSTextAlignmentRight;
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:RGBCOLOR(0,122,255)];
        [cell.contentView addSubview:nameLabel];
        UILabel *phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 40)];
        phoneLabel.text = [node.phoneNum objectForKey:@"tmpPhoneIndex"];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [phoneLabel setFont:[UIFont systemFontOfSize:12]];
        [phoneLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:phoneLabel];
//         cell.textLabel.attributedText =node.phoneNum;
    }else{
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50)];
        nameLabel.text = node.nodeData;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:nameLabel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
        NSDictionary *phoneDic= [NSDictionary dictionaryWithObjectsAndKeys:node.nodeData,@"phoneName",[node.phoneNum objectForKey:@"tmpPhoneIndex"],@"phoneNumber", nil];
        if (self.phoneBlock!=nil) {
            self.phoneBlock(phoneDic);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"删除 %ld",indexPath.row);
    [_displayArray removeObjectAtIndex:indexPath.row];
    //删除动画
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates];
}

#pragma mark 点击电话号回调
-(void)didSelectPhoneNumber:(SelectPhoneNumberBlock)phoneBlock{
    self.phoneBlock = phoneBlock;
}

#pragma mark 返回
-(void)back:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSMutableArray arrayWithArray:tmp];
    [self.myTableView reloadData];
}



/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(NSDictionary *phone in node.sonNodes){
                CLTreeViewNode *node2 = [[CLTreeViewNode alloc]init];
                node2.nodeData = node.nodeData;
                node2.phoneNum = phone;
                node2.type = 2;
                node2.isExpanded = NO;
                node2.sonNodes = nil;
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;

            }
        }
    }
    _displayArray = [NSMutableArray arrayWithArray:tmp];
    [self.myTableView reloadData];
}

#pragma mark 电话标签解析
-(NSString *)displayPropertyName:(NSString *) propConst{
    if ([propConst isEqualToString:@"_$!<Home>!$_"]){
        return @"住宅";
    }else if ([propConst isEqualToString:@"_$!<HomeFAX>!$_"]){
        return @"住宅传真";
    }else if ([propConst isEqualToString:@"_$!<Main>!$_"]){
        return @"主要";
    }else if ([propConst isEqualToString:@"_$!<Mobile>!$_"]){
        return @"移动";
    }else if ([propConst isEqualToString:@"_$!<Other>!$_"]){
        return @"其他";
    }else if ([propConst isEqualToString:@"_$!<Pager>!$_"]){
        return @"传呼";
    }else if ([propConst isEqualToString:@"_$!<Work>!$_"]){
        return @"工作";
    }else if ([propConst isEqualToString:@"_$!<WorkFAX>!$_"]){
        return @"工作传真";
    }

    
    return propConst;
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
