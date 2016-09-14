//
//  ContactsListViewController.h
//  
//
//  Created by admin on 15/11/17.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreText/CoreText.h>
typedef void (^SelectPhoneNumberBlock)(NSDictionary *phoneDic);

@interface ContactsListViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)UITableView *myTableView;
@property (nonatomic,strong)SelectPhoneNumberBlock phoneBlock;

-(void)didSelectPhoneNumber:(SelectPhoneNumberBlock)phoneBlock;

@end
