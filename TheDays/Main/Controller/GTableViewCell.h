//
//  GTableViewCell.h
//  TheDays
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Events;
@interface GTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+ (instancetype)createCell:(UITableView *)tableView WithEvent:(Events *)cellEvent;

@end
