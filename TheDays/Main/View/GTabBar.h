//
//  GTabBar.h
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTabBar;
@protocol GTabBarDelegate <NSObject>
@optional
- (void)didSelectedAddButton:(GTabBar *)tabBar;

@end
@interface GTabBar : UITabBar
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic,weak) id <GTabBarDelegate> gDelegate;
@end
