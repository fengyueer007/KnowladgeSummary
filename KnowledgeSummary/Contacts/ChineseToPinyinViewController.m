//
//  ChineseToPinyinViewController.m
//  
//
//  Created by admin on 15/12/1.
//
//

#import "ChineseToPinyinViewController.h"
#import "PhoneWithPersonViewController.h"
#import "CLTreeViewNode.h"
#import "ChineseString.h"
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface ChineseToPinyinViewController ()<UISearchBarDelegate>
@property (strong ,nonatomic)NSMutableArray *dataArray;//保存全部数据的数组
//@property (strong ,nonatomic)NSMutableArray *displayArray;//保存要显示在界面上的数据的数组
@property (strong ,nonatomic)UISearchBar *personSearchBar;

@property(nonatomic,strong)NSMutableArray *indexArray;//右侧搜索
@property(nonatomic,strong)NSMutableArray *letterResultArr;//排序分组

@end

@implementation ChineseToPinyinViewController

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
    NSMutableArray *pArray = [[NSMutableArray alloc]initWithCapacity:0];
    for(id tmpPerson in tmpPeoples){
        
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        //公司
        NSString *organization = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);

        CLTreeViewNode *phoneNameNode = [[CLTreeViewNode alloc]init];
        phoneNameNode.nodeData =[NSString stringWithFormat:@"%@%@",tmpLastName==nil?@"":tmpLastName,tmpFirstName==nil?@"":tmpFirstName];
        phoneNameNode.organization = organization == nil?@"":organization;
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
        [pArray addObject:phoneNameNode.nodeData];
    }
    _indexArray = [ChineseString IndexArray:pArray];
    _letterResultArr = [ChineseString LetterSortArray:pArray];
    
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    return 50;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [_indexArray objectAtIndex:section];
    return key;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    lab.backgroundColor = [UIColor grayColor];
//    lab.text = [self.indexArray objectAtIndex:section];
//    lab.textColor = [UIColor whiteColor];
//    return lab;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[_letterResultArr objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indentifier = @"level0cell_1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhoneWithPersonViewController *phoneVC = [[PhoneWithPersonViewController alloc]init];
    NSString *nodeString = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (CLTreeViewNode *treeNode in _dataArray) {
        if ([nodeString isEqualToString:treeNode.nodeData]) {
            phoneVC.node = treeNode;
        }
    }
    [self.navigationController pushViewController:phoneVC animated:YES];
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



#pragma mark 点击电话号回调
//-(void)didSelectPhoneNumber:(SelectPhoneNumberBlock)phoneBlock{
//    self.phoneBlock = phoneBlock;
//}

#pragma mark 返回
-(void)back:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
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
