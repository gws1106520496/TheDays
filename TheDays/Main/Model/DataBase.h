//
//  DataBase.h
//  TheDays
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBase : NSObject

- (BOOL)execSql:(NSString *)sqlStr;
+ (BOOL)execSql:(NSString *)sqlStr;
@end
