//
//  PhoneWithPersonViewController.m
//  
//
//  Created by admin on 15/12/1.
//
//

#import "PhoneWithPersonViewController.h"
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@interface PhoneWithPersonViewController ()
{
    UITableView *tabView;
}
@end

@implementation PhoneWithPersonViewController
{
    NSMutableArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setPersonLabel];
}

-(void)setPersonLabel{
    tabView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.delegate = self;
    tabView.dataSource= self;
    [self.view addSubview:tabView];
    
    UIView *personView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UILabel *personNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, 30)];
    personNameLabel.text = _node.nodeData;
    [personView addSubview:personNameLabel];
    
    UILabel *personOrganization = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, self.view.frame.size.width, 20)];
    personOrganization.text = _node.organization;
    personOrganization.font = [UIFont systemFontOfSize:14];
    [personView addSubview:personOrganization];
    
    
    tabView.tableHeaderView = personView;
    dataArray = [NSMutableArray arrayWithArray:_node.sonNodes];
    [tabView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableString = @"tableString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableString];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableString];
    }
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
//    NSString *cellString = [[NSString alloc]initWithFormat:@"%@  %@",[dic objectForKey:@"tmpLabel"],[dic objectForKey:@"tmpPhoneIndex"]];
//    cell.textLabel.text =cellString;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200,25)];
    nameLabel.text = [dic objectForKey:@"tmpLabel"];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:RGBCOLOR(0,122,255)];
    [cell.contentView addSubview:nameLabel];
    UILabel *phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 25)];
    phoneLabel.text = [dic objectForKey:@"tmpPhoneIndex"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:phoneLabel];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    NSDictionary *phoneDic= [NSDictionary dictionaryWithObjectsAndKeys:_node.nodeData,@"phoneName",[dic objectForKey:@"tmpPhoneIndex"],@"phoneNumber", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneDidSelect" object:nil userInfo:phoneDic];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
