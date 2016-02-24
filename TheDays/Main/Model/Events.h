//
//  Events.h
//  TheDays
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 student. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DataBase.h"

@interface Events : DataBase
@property (nonatomic, assign) int uId;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *classify;
@property (nonatomic, copy) NSString *imageNum;

+ (instancetype)eventWithuId:(int)uId andPhoneNum:(NSString *)phoneNum andTitle:(NSString *)title andDate:(NSString *)date andClassify:(NSString *)classify andImageNum:(NSString *)imageNum;
- (NSMutableArray *)loadDataFromDB;

+ (BOOL)insertEvent:(Events *)event;
+ (void)editEvent:(Events *)event;
+ (void)deleteEventWIthUId:(int)uId;
@end