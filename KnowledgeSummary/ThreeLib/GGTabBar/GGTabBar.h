//
//  VITabBar.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGTabBarDelegate;

@interface GGTabBar : UIView
@property (nonatomic, weak) id<GGTabBarDelegate> delegate;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIViewController *selectedViewController;

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers appearance:(NSDictionary *)appearance;
- (void)setAppearance:(NSDictionary *)appearance;
- (void)startDebugMode;
@end

@protocol GGTabBarDelegate <NSObject>
- (void)tabBar:(GGTabBar *)tabBar didPressButton:(UIButton *)button atIndex:(NSUInteger)tabIndex;
@end

