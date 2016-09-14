//
//  VITabBarController.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGTabBarControllerDelegate;

@interface GGTabBarController : UIViewController
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <GGTabBarControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *tabBarAppearanceSettings;
@property (nonatomic, assign) BOOL debug;
@end

@protocol GGTabBarControllerDelegate <NSObject>
@optional
- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end
