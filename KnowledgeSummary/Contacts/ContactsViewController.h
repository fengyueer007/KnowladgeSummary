//
//  ContactsViewController.h
//  
//
//  Created by admin on 15/11/10.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
/*
 添加 
    AddressBookUI.framework
    AddressBook.framework
 */
@interface ContactsViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>
{
    ABPeoplePickerNavigationController *picker;
//    ABNewPersonViewController *personViewController;
}
@end
