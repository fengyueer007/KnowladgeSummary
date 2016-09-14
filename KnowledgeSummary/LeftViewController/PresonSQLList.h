//
//  PresonSQLList.h
//  
//
//  Created by admin on 15/12/1.
//
//

#import <Foundation/Foundation.h>

@interface PresonSQLList : NSObject
-(void)createPresonSQLList;//创建数据库
-(NSString *)insertSecurityCode:(NSString *)phone;//插入验证码
-(NSString *)selestSecurityCode:(NSString *)phone;//查询验证码
-(NSString *)selestUser:(NSString *)phone;//查询密码
-(NSString *)createUser:(NSString *)phone andPwd:(NSString *)pwd;//注册

@end
