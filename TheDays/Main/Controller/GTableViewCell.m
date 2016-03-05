//
//  GTableViewCell.m
//  TheDays
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 student. All rights reserved.
//

#import "GTableViewCell.h"
#import "Events.h"

@implementation GTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)createCell:(UITableView *)tableView WithEvent:(Events *)cellEvent
{
    static NSString *identifier = @"myCell";
    GTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.eventImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"btnbg%@",cellEvent.imageNum]];
    
    cell.titleLabel.text = cellEvent.title;
    cell.subTitleLabel.text = [cellEvent.createDate substringToIndex:10];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@ 天",cellEvent.date];
    return cell;

    
}
@end
