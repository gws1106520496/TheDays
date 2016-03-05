//
//  Events.m
//  TheDays
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 student. All rights reserved.
//

#import "Events.h"
extern sqlite3 *db; //extern 引用外部变量
@implementation Events
//向类发送消息时调用（方法的调用） 而且一般之调用一次
+ (void)initialize
{
    NSString *sqlStr = @"create table if not exists e_event (uId integer PRIMARY KEY,phoneNum text NOT NULL,title text NOT NULL,date text NOT NULL,classify text NOT NULL,imageNum text NOT NULL,createDate text NOT NULL,setCover int NOT NULL,findTag int NOT NULL)";
    [self execSql:sqlStr];
}

- (instancetype)initEventWithuId:(int)uId andPhoneNum:(NSString *)phoneNum andTitle:(NSString *)title andDate:(NSString *)date andClassify:(NSString *)classify andImageNum:(NSString *)imageNum andCreateDate:(NSString *)createDate andSetCover:(int)setCover andFindTag:(int)findTag
{
    if (self = [super init]) {
        _uId = uId;
        _phoneNum = phoneNum;
        _title = title;
        _date = date;
        _classify = classify;
        _imageNum = imageNum;
        _createDate = createDate;
        _setCover = setCover;
        _findTag = findTag;
    }
    return self;
}

+ (instancetype)eventWithuId:(int)uId andPhoneNum:(NSString *)phoneNum andTitle:(NSString *)title andDate:(NSString *)date andClassify:(NSString *)classify andImageNum:(NSString *)imageNum andCreateDate:(NSString *)createDate andSetCover:(int)setCover andFindTag:(int)findTag
{
    return [[[self class]alloc]initEventWithuId:uId andPhoneNum:phoneNum andTitle:title andDate:date andClassify:classify andImageNum:imageNum andCreateDate:createDate andSetCover:setCover andFindTag:findTag];
}

/**
 加载数据
 */
- (NSMutableArray *)loadDataFromDB
{
    NSMutableArray *backArray = [NSMutableArray array];
    //打开数据库
    NSString *searchSql = @"select *from e_event";
    sqlite3_stmt *stmt;
    int status = sqlite3_prepare_v2(db, searchSql.UTF8String, -1, &stmt, NULL);
    
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int uId = sqlite3_column_int(stmt, 0);
            const char *phoneNum = (const char *)sqlite3_column_text(stmt, 1);
            const char *title = (const char *)sqlite3_column_text(stmt, 2);
            const char *date = (const char *)sqlite3_column_text(stmt, 3);
            const char *classify = (const char *)sqlite3_column_text(stmt, 4);
            const char *imageNum = (const char *)sqlite3_column_text(stmt, 5);
            const char *createDate = (const char *)sqlite3_column_text(stmt, 6);
            const int  setCover = (const int)sqlite3_column_int(stmt, 7);
            const int  findTag = (const int)sqlite3_column_int(stmt, 8);
            //c->oc
            NSString *phoneNumStr = [NSString stringWithUTF8String:phoneNum];
            NSString *titleStr = [NSString stringWithUTF8String:title];
            NSString *dateStr = [NSString stringWithUTF8String:date];
            NSString *classifyStr = [NSString stringWithUTF8String:classify];
            NSString *imageNumStr = [NSString stringWithUTF8String:imageNum];
            NSString *createDateStr = [NSString stringWithUTF8String:createDate];
            int setCoverStr = setCover;
            int findTagStr = findTag;
            
            Events *event = [Events eventWithuId:uId andPhoneNum:phoneNumStr andTitle:titleStr andDate:dateStr andClassify:classifyStr andImageNum:imageNumStr andCreateDate:createDateStr andSetCover:setCoverStr andFindTag:findTagStr];
            
            [backArray addObject:event];
        }
        sqlite3_finalize(stmt);//释放内存
    }
    return backArray;
}

/**
 插入数据
 */

+ (BOOL)insertEvent:(Events *)event
{
    NSString *insertSqlStr = [NSString stringWithFormat:@"insert into e_event (phoneNum,title,date,classify,imageNum,createDate,setCover,findTag) values ('%@','%@','%@','%@','%@','%@','%d','%d')",event.phoneNum,event.title,event.date,event.classify,event.imageNum,event.createDate,event.setCover,event.findTag];
    return [self execSql:insertSqlStr];
}

/**
 修改数据
 */
+ (void)editEvent:(Events *)event
{
    NSString *updateSql = [NSString stringWithFormat:@"update e_event set phoneNum='%@',title='%@',date='%@',classify='%@',imageNum='%@',createDate='%@',setCover='%d',findTag='%d' where findTag='%d'",event.phoneNum,event.title,event.date,event.classify,event.imageNum,event.createDate,event.setCover,event.findTag,event.findTag];
    [self execSql:updateSql];
}

/**
 删除数据
 */
+ (void)deleteEventWIthUId:(int)findTag
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete  from e_event where findTag='%i'",findTag];
    [self execSql:deleteSql];
}

//@property (nonatomic, assign) int uId;
//@property (nonatomic, copy) NSString *phoneNum;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *date;
//@property (nonatomic, copy) NSString *classify;
//@property (nonatomic, copy) NSString *imageNum;
//@property (nonatomic, copy) NSString *createDate;
@end
