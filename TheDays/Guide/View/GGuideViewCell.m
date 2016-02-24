//
//  GGuideViewCell.m
//  TheDays
//
//  Created by student on 16/1/28.
//  Copyright © 2016年 student. All rights reserved.
//

#import "GGuideViewCell.h"
#import "LoginViewController.h"

@interface GGuideViewCell()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *useButton;

@end

@implementation GGuideViewCell
- (UIImageView *)imageView{
    if (_imageView == nil){
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageV;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
    
}

- (UIButton *)useButton{
    
    if (_useButton==nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width*75/320, self.frame.size.height - winSize.height*100/568, self.frame.size.width - winSize.width*150/320, winSize.height*50/568)];
        [button setBackgroundImage:[UIImage imageNamed:@"LoginBg"] forState:UIControlStateNormal];
        //button的事件放在controller中处理
        //传递方式：1.target:self 通过代理传递事件 2:target:controller action写在controller中
        [button addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
        
        _useButton = button;
        
        
        [self addSubview:_useButton];
    }
    
    return _useButton;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}



/**
 *  判断当前的cell是最后一张引导页
 */
- (void)setCurrentIndex:(int)currentIndex{
    _currentIndex = currentIndex;
    //如果是最后一张图片
    if (_currentIndex==3) {
        //添加进入按钮
        [self useButton];
    }else{
        if (_useButton) {
            [_useButton removeFromSuperview];
        }
    }
}


- (void)goToMainView
{
    //更改根视图控制器
    //1.(window->App(UIApplication)Delegate)
    //    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    //2.[UIApplication sharedApplication].keyWindow
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    
    //addChild...
    
    //    app.window.rootViewController = tabBarController;
    
    //    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    
    GKeyWindow.rootViewController = loginController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"1" forKey:GFirstLaunch];
    [defaults synchronize];
}

@end
