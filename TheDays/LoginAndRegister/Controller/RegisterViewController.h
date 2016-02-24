//
//  RegisterViewController.h
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GLoginDelegate <NSObject>

@optional
- (void)didRegister:(NSDictionary *)infoDic;
@end

@interface RegisterViewController : UIViewController
@property (nonatomic, weak) id <GLoginDelegate>gLoginDelegate;
@end
