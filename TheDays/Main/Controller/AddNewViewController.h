//
//  AddNewViewController.h
//  TheDays
//
//  Created by student on 16/2/21.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Events;
@interface AddNewViewController : UIViewController
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) Events *eventEdit;
@property (nonatomic, assign) BOOL modify;
@end
