//
//  VITabBarController-Private.h
//  KnowledgeSummary
//
//  Created by tidy on 15/11/5.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import "GGTabBar.h"

// Exposes methods for testing
@interface GGTabBar (Private)
- (NSString *)visualFormatConstraintStringWithButtons:(NSArray *)buttons
                                           separators:(NSArray *)separators
                                     marginSeparators:(NSArray *)marginSeparators;

- (NSDictionary *)visualFormatStringViewsDictionaryWithButtons:(NSArray *)buttons
                                                    separators:(NSArray *)separators
                                              marginSeparators:(NSArray *)marginSeparators;
@end

