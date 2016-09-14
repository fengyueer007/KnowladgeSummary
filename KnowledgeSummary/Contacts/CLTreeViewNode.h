//
//  CLTreeViewNode.h
//  
//
//  Created by admin on 15/11/17.
//
//

#import <Foundation/Foundation.h>

@interface CLTreeViewNode : NSObject

@property(nonatomic,copy)NSDictionary *phoneNum;
@property(nonatomic) int type;//节点类型
@property(nonatomic) id nodeData;//节点数据
@property(nonatomic) BOOL isExpanded;//节点是否展开
@property(nonatomic,strong) NSMutableArray *sonNodes;//子节点
@property(nonatomic,strong) NSString *organization;

@end
