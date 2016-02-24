//
//  GTFAccessoryView.h
//  TheDays
//
//  Created by student on 16/2/21.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTFAccessoryView;
@protocol GTFAccessoryViewDelegate <NSObject>

@optional
- (void)tfAccessoryView:(GTFAccessoryView *)tfView didSelectedCancelButton:(UIButton *)button;
- (void)tfAccessoryView:(GTFAccessoryView *)tfView didSelectedDownButton:(UIButton *)button;

@end
@interface GTFAccessoryView : UIView
@property (nonatomic, weak)id<GTFAccessoryViewDelegate>GTFdelegate;
@end
