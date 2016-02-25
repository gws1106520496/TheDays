//
//  ListViewController.h
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Events.h"
@protocol SetUpUIDelegate <NSObject>

- (void)SetUpUI:(NSDictionary *)dataDic;

@end
@interface ListViewController : UIViewController
@property (nonatomic, weak) id<SetUpUIDelegate>gSetUpUIDelegate;
@end
