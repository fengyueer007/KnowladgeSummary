//
//  MainViewController.m
//  KnowledgeSummary
//
//  Created by tidy on 15/11/6.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import "MainViewController.h"
#import "GGTabBarController.h"
#import "PersonalViewController.h"
#include "AdvertisingScrollViewController.h"
@implementation MainViewController{
    UITabBarController *tabBar;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
//    GGTabBarController *tabBar = [[GGTabBarController alloc]init];
    tabBar = [[UITabBarController alloc]init];
    [self.view addSubview:tabBar.view];
    PersonalViewController *personalViewController = [[PersonalViewController alloc]init];
    AdvertisingScrollViewController *adScrollerViewController = [[AdvertisingScrollViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:personalViewController];
    
    tabBar.viewControllers = @[nav,adScrollerViewController];
    
    [self loadTabBarImage];
    
    tabBar.selectedIndex = 0;
    
    
}

-(void)loadTabBarImage{
//    [tabBar.tabBar setBackgroundImage:[UIImage imageNamed:@"zhanweitu.jpg"]];
    NSArray *ar = tabBar.viewControllers;
    NSMutableArray *arD = [[NSMutableArray alloc]initWithCapacity:0];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        UITabBarItem *item = nil;
        [UIImage imageNamed:@""];
        switch (idx) {
            case 0:
                item = [[UITabBarItem alloc] initWithTitle:@"个人"
                                                     image:[UIImage imageNamed:@"user_pressed"]
                                             selectedImage:[UIImage imageNamed:@"user_normal"]];
                break;
            case 1:
                item = [[UITabBarItem alloc] initWithTitle:@"滚动"
                                                     image:[UIImage imageNamed:@"cloud_pressed"]
                                             selectedImage:[UIImage imageNamed:@"cloud_normal"]];
                break;
            default:
                break;
        }
        viewController.tabBarItem = item;
        [arD addObject:viewController];
    }];
    tabBar.viewControllers = arD;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
