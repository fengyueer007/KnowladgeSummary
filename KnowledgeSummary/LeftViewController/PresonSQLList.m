//
//  PresonSQLList.m
//  
//
//  Created by admin on 15/12/1.
//
//

#import "PresonSQLList.h"
#import <sqlite3.h>
#define DBNAME @"person.sqlite"
#define PHONE  @"phone"
#define PWD    @"password"


//先加入sqlite开发库libsqlite3.dylib
@implementation PresonSQLList{
    sqlite3 *db;
}
/*
 sqlite3          *db, 数据库句柄，跟文件句柄FILE很类似
 sqlite3_stmt      *stmt, 这个相当于ODBC的Command对象，用于保存编译好的SQL语句
 sqlite3_open(),   打开数据库，没有数据库时创建。
 sqlite3_exec(),   执行非查询的sql语句
 Sqlite3_step(), 在调用sqlite3_prepare后，使用这个函数在记录集中移动。
 Sqlite3_close(), 关闭数据库文件
 还有一系列的函数，用于从记录集字段中获取数据，如
 sqlite3_column_text(), 取text类型的数据。
 sqlite3_column_blob（），取blob类型的数据
 sqlite3_column_int(), 取int类型的数据
 
 */

#pragma mark 创建数据库
-(void)createPresonSQLList{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];//获取应用在设备中得路径
    NSString *fileName = [doc stringByAppendingPathComponent:DBNAME];
    const char *cfileName = fileName.UTF8String;
    NSInteger result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSString *sqlString = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,name bigint(11),password varchar(6) DEFAULT '000000',securitycode varchar(6) DEFAULT '000000')"];
        const char *sql = [sqlString cStringUsingEncoding:NSASCIIStringEncoding];
        char *errmsq = NULL;
        result = sqlite3_exec(db, sql, NULL, NULL, &errmsq);
        if (result==SQLITE_OK) {
            NSLog(@"创建数据库成功");
        }else{
            NSLog(@"失败error=%s",errmsq);
        }
    }else{
        NSLog(@"打开数据库失败");
    }
    sqlite3_close(db);
}
#pragma mark 注册
-(NSString *)createUser:(NSString *)phone andPwd:(NSString *)pwd{
    NSString *string = [self selestSecurityCode:phone];
    if (string !=nil) {
        return @"该账号已经存在";
    }
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:DBNAME];
    const char *cfileName = fileName.UTF8String;
    NSInteger result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSString *sql = nil;
        sql = [NSString stringWithFormat:@"INSERT INTO PERSONINFO (name,password) VALUES ('%@','%@')",phone,pwd];
        char *errmsg = NULL;
        sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            sqlite3_close(db);
            return @"注册失败";
        }else{
            sqlite3_close(db);
            return @"注册成功";
        }
    }else{
        sqlite3_close(db);
        return @"打开数据库失败";
    }
}
#pragma mark 查询验证码
-(NSString *)selestSecurityCode:(NSString *)phone{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:DBNAME];
    const char *cfileName = fileName.UTF8String;
    NSInteger result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSString *sql = nil;
        sql = [NSString stringWithFormat:@"SELECT securitycode FROM PERSONINFO WHERE name = %@",phone];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                char *securitycode = (char *)sqlite3_column_text(stmt, 0);
                
                NSString *securitycodeString = [[NSString alloc ]initWithUTF8String:securitycode];
                sqlite3_close(db);
                return securitycodeString;
            }
            sqlite3_finalize(stmt);
        }
    }
    sqlite3_close(db);
    return nil;
}
#pragma mark 查询密码
-(NSString *)selestUser:(NSString *)phone{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:DBNAME];
    const char *cfileName = fileName.UTF8String;
    NSInteger result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSString *sql = nil;
        sql = [NSString stringWithFormat:@"SELECT password FROM PERSONINFO WHERE name = %@",phone];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                char *securitycode = (char *)sqlite3_column_text(stmt, 0);
                
                NSString *password = [[NSString alloc ]initWithUTF8String:securitycode];
                sqlite3_close(db);
                return password;
            }
            sqlite3_finalize(stmt);
        }
    }
    sqlite3_close(db);
    return nil;

}
#pragma mark 插入验证码
-(NSString *)insertSecurityCode:(NSString *)phone{
    
    
    int randomInt  = arc4random()%1000000;
    if (randomInt<100000) {
        randomInt += 100000 * (arc4random()%10);
    }
    NSString *string = [[NSString alloc]initWithFormat:@"%d",randomInt];
    
    NSString *securityCode = [self selestSecurityCode:phone];//检查手机号是否存在
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:DBNAME];
    const char *cfileName = fileName.UTF8String;
    NSInteger result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSString *sql = nil;
        if (securityCode ==nil) { //不存在时先创建
            sql = [NSString stringWithFormat:@"INSERT INTO PERSONINFO (name,password) VALUES ('%@','%@')",phone,@"000000"];
            char *errmsg = NULL;
            sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);

        }
        sqlite3_stmt *stmt;
        sql = [NSString stringWithFormat:@"UPDATE PERSONINFO SET securitycode = \"%@\" WHERE name = \"%@\" ",string,phone];//更新验证码
        if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                sqlite3_finalize(stmt);
                return string;
            }
        }else{
            sqlite3_finalize(stmt);
        }

//        sqlite3_finalize(stmt);
    }
    sqlite3_close(db);
    return nil;
}
@end
