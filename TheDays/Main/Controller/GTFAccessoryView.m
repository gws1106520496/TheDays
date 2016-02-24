//
//  GTFAccessoryView.m
//  TheDays
//
//  Created by student on 16/2/21.
//  Copyright © 2016年 student. All rights reserved.
//

#import "GTFAccessoryView.h"

@implementation GTFAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cancelAction:(id)sender {
    if ([self.GTFdelegate respondsToSelector:@selector(tfAccessoryView:didSelectedCancelButton:)]) {
        [self.GTFdelegate tfAccessoryView:self didSelectedCancelButton:sender];
    }
}

- (IBAction)downAction:(id)sender {
    if ([self.GTFdelegate respondsToSelector:@selector(tfAccessoryView:didSelectedDownButton:)]) {
        [self.GTFdelegate tfAccessoryView:self didSelectedDownButton:sender];
    }
}

@end
