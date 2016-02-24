//
//  UIImage+GImage.m
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import "UIImage+GImage.h"

@implementation UIImage (GImage)

+ (UIImage *)imageWithRenderingOriginal:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
