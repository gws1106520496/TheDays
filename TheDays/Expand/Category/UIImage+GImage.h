//
//  UIImage+GImage.h
//  TheDays
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GImage)
//返回禁止渲染的图片
+ (UIImage *)imageWithRenderingOriginal:(NSString *)imageName;
@end
