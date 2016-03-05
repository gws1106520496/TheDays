//
//  Utils.m
//  TheDays
//
//  Created by student on 16/2/26.
//  Copyright © 2016年 student. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (NSString *)getDistanceDayStr:(NSString *)inDate
{
    long dd;
    BOOL before;
    NSString *timeString = @"";
    NSDateFormatter *onceFormatter = [[NSDateFormatter alloc]init];
    [onceFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *now1 = [NSDate date];
    NSString *dayStr;
    
    //    NSString *str1 = [cellEvent.createDate substringToIndex:10];
    NSString *nowDateStr = [[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10] stringByAppendingString:@" 00:01:00"];
    NSString *addDateStr = [[inDate substringToIndex:10] stringByAppendingString:@" 00:00:00"];
    
    NSDate *addDate = [onceFormatter dateFromString:addDateStr];
    NSDate *now = [onceFormatter dateFromString:nowDateStr];
    
    if ([now timeIntervalSince1970] > [addDate timeIntervalSince1970]) {
        dd = (long)[now timeIntervalSince1970] - [addDate timeIntervalSince1970];
        before = YES;
    }else{
        dd = (long)[addDate timeIntervalSince1970] - [now timeIntervalSince1970];
        before = NO;
    }
    
    if (dd/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%ld",dd/86400];
        if (before) {
            dayStr = [NSString stringWithFormat:@"+%@",timeString];
        }else{
            dayStr = [NSString stringWithFormat:@"-%@",timeString];
        }
        
    }else{
        dayStr = @"0";
    }
    return dayStr;
}
@end
