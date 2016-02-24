//
//  DataBase.m
//  TheDays
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 student. All rights reserved.
//

#import "DataBase.h"
sqlite3 *db;//外部变量
@implementation DataBase
+ (void)initialize
{
    //打开数据库
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = [path stringByAppendingString:@"/event.db"];
    int status = sqlite3_open(filePath.UTF8String, &db);
    if (status == SQLITE_OK) {
        NSLog(@"open db sucess");
    }else{
        NSLog(@"open db failed...");
    }
}

- (BOOL)execSql:(NSString *)sqlStr
{
    char *errmsg = NULL;
    sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, &errmsg);
    
    if (errmsg) {
        NSLog(@"operate failed---reason:%s",errmsg);
        sqlite3_close(db);
        return NO;
    }else{
        NSLog(@"operate success...");
        return YES;
    }
}

+ (BOOL)execSql:(NSString *)sqlStr
{
    DataBase *database = [[DataBase alloc] init];
    return [database execSql:sqlStr];
}
@end
