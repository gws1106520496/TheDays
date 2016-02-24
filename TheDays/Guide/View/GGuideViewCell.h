//
//  GGuideViewCell.h
//  TheDays
//
//  Created by student on 16/1/28.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GGuideVIewController;
@interface GGuideViewCell : UICollectionViewCell
//接受图片名
@property (nonatomic, strong) NSString *imageName;
//告知当前cell是第几张图片
@property (nonatomic, assign) int currentIndex;
@end
